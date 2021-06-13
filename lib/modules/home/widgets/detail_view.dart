import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wms_mobile/domain/blocs/cubit/loading_cubit.dart';
import 'package:wms_mobile/domain/models/item.dart';
import 'package:wms_mobile/domain/services/api.dart';
import 'package:wms_mobile/modules/home/cubit/home_cubit.dart';
import 'package:wms_mobile/widgets/info_tile.dart';
import 'package:wms_mobile/widgets/primary_button.dart';

class DetailView extends StatefulHookWidget {
  const DetailView({required this.bloc, Key? key, required this.item})
      : super(key: key);

  final HomeCubit bloc;
  final Item item;

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  bool editing = false;
  late Item _item;
  final _api = GetIt.I<Api>();

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  Future<List<String>> _suggestionsCallback(String pattern) async {
    if (pattern.isEmpty) return [];
    final res =
        await _api.client.get(Uri.parse(_api.baseUrl + '/country/$pattern'));
    final data = jsonDecode(res.body);
    print(data.map((e) => e['name']));
    return data.map((e) => e['name']).toList().cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    print(_item);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            EditableInfoTile(
              configuration: EditableConfiguration(
                type: EditType.text,
                onChanged: (value) {
                  setState(() {
                    _item = _item.copyWith(name: value);
                  });
                },
              ),
              editing: editing,
              infoTile: InfoTile(
                title: _item.name,
                subtitle: 'Название товара',
              ),
            ),
            EditableInfoTile(
              editing: editing,
              configuration: EditableConfiguration(
                type: EditType.text,
                onChanged: (value) {
                  setState(() {
                    _item = _item.copyWith(price: double.tryParse(value));
                  });
                },
              ),
              infoTile: InfoTile(
                title: _item.price.toString(),
                subtitle: 'Цена',
              ),
            ),
            EditableInfoTile(
              editing: editing,
              configuration: EditableConfiguration(
                type: EditType.typeAhead,
                suggestionsCallback: _suggestionsCallback,
                onChanged: (value) {
                  setState(() {
                    _item = _item.copyWith(country: value);
                  });
                },
              ),
              infoTile: InfoTile(
                title: _item.country,
                subtitle: 'Страна',
              ),
            ),
            EditableInfoTile(
              editing: editing,
              configuration: EditableConfiguration(
                type: EditType.select,
                suggestions: mapStatusToText.values.toList(),
                onChanged: (value) {
                  setState(() {
                    _item = _item.copyWith(
                        status: mapStatusToText.keys.firstWhere(
                            (element) => mapStatusToText[element] == value));
                  });
                },
              ),
              infoTile: InfoTile(
                title: mapStatusToText[_item.status]!,
                subtitle: 'Статус',
              ),
            ),
            Divider(),
            InfoTile(
              title: _item.supplyCode,
              subtitle: 'Код товара',
            ),
            InfoTile(
              title: Jiffy(_item.departureAt).format('d MMM yyyy, HH:mm'),
              subtitle: 'Дата поставки',
            ),
            InfoTile(
              title: Jiffy(_item.expiresAt).format('d MMM yyyy, HH:mm'),
              subtitle: 'Годен до',
            ),
            PrimaryButton(
                onPressed: () async {
                  if (editing) {
                    context.read<LoadingCubit>().startLoading();
                    print(_item);
                    await widget.bloc.updateItem(_item);
                    context.read<LoadingCubit>().stopLoading();
                  }
                  setState(() {
                    editing = !editing;
                  });
                },
                child: Text(editing ? 'Сохранить' : 'Изменить'))
          ],
        ),
      ),
    );
  }
}
