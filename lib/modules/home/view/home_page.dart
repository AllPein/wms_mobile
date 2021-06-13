import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_it/get_it.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wms_mobile/domain/blocs/cubit/loading_cubit.dart';
import 'package:wms_mobile/domain/models/item.dart';
import 'package:wms_mobile/domain/services/api.dart';
import 'package:wms_mobile/modules/home/cubit/home_cubit.dart';
import 'package:wms_mobile/modules/home/widgets/cells_view.dart';
import 'package:wms_mobile/modules/home/widgets/equipments_view.dart';
import 'package:wms_mobile/modules/home/widgets/items_view.dart';

const double _fabDimension = 56.0;

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  int _index = 0;
  final titles = ['Товары', 'Ячейки', 'Оборудование'];

  final _tabs = <Widget>[ItemsView(), CellsView(), EquipmentView()];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(titles[_index]),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          children: _tabs,
        ),
        floatingActionButton: _buildFab(context),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _controller.index,
          onTap: (index) {
            setState(() {
              _index = index;
            });
            _controller.animateTo(index);
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.inventory), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.construction), label: ''),
          ],
        ));
  }

  Widget? _buildFab(BuildContext context) {
    switch (_controller.index) {
      case 0:
        return OpenContainer(
            openBuilder: (_, action) => BlocProvider.value(
                value: context.read<HomeCubit>(),
                child: AddItemView(action: action)),
            closedElevation: 6.0,
            closedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(_fabDimension / 2),
              ),
            ),
            closedColor: Theme.of(context).primaryColor,
            closedBuilder: (context, action) => SizedBox(
                  height: _fabDimension,
                  width: _fabDimension,
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ));
      case 1:
        return null;
      case 2:
        return FloatingActionButton(
          heroTag: 'fab',
          onPressed: () {
            showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365 * 2)),
                firstDate: DateTime.now().subtract(Duration(days: 365 * 2)));
          },
          child: Icon(Icons.add),
        );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AddItemView extends StatefulHookWidget {
  final VoidCallback action;
  const AddItemView({Key? key, required this.action}) : super(key: key);

  @override
  _AddItemViewState createState() => _AddItemViewState();
}

class _AddItemViewState extends State<AddItemView> {
  Item _item = Item.empty
      .copyWith(status: ItemStatus.INSTOCK, expiresAt: DateTime.now());
  final _api = GetIt.I<Api>();

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
    final priceController = useTextEditingController();
    final countryController = useTextEditingController();
    final nameController = useTextEditingController();
    final codeController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        shadowColor: Colors.black,
        foregroundColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.only(top: 11.0),
          child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: const Icon(Icons.close),
            color: Colors.black54,
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            onPressed: widget.action,
          ),
        ),
        toolbarHeight: 45,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size(110, 50)),
              onPressed: () async {
                final item = _item.copyWith(
                    name: nameController.text,
                    price: double.parse(priceController.text),
                    country: countryController.text,
                    expiresAt: _item.expiresAt.toUtc(),
                    status: ItemStatus.INSTOCK,
                    supplyCode: codeController.text);
                context.read<LoadingCubit>().startLoading();
                await context.read<HomeCubit>().addItem(item);
                await Future.delayed(Duration(milliseconds: 300));
                context.read<LoadingCubit>().stopLoading();
                widget.action();
              },
              child: BlocBuilder<LoadingCubit, bool>(
                builder: (context, state) {
                  if (state)
                    return SizedBox(
                      width: 20,
                      height: 15,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    );
                  return Text('Сохранить');
                },
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 60.0),
            child: TextField(
              controller: nameController,
              maxLines: null,
              style: TextStyle(fontSize: 24),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Добавьте название',
                  hintStyle: TextStyle(fontSize: 24)),
            ),
          ),
          Divider(
            thickness: 0.87,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Icon(Icons.calendar_today),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Годен до', style: TextStyle(fontSize: 16)),
                  TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.black, padding: EdgeInsets.zero),
                      onPressed: () async {
                        final res = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(Duration(days: 365 * 2)),
                            firstDate: DateTime.now()
                                .subtract(Duration(days: 365 * 2)));
                        print(res);
                        if (res != null) {
                          setState(() {
                            _item = _item.copyWith(expiresAt: res);
                          });
                        }
                      },
                      child:
                          Text(Jiffy(_item.expiresAt).format('dd MMM yyyy'))),
                ],
              )
            ],
          ),
          Divider(
            thickness: 0.87,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.language),
              ),
              Expanded(
                  child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: countryController,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                          hintText: 'Cтрана',
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: ConstrainedBox(
                              constraints:
                                  BoxConstraints(minHeight: 15, maxWidth: 100),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [],
                              ),
                            ),
                          ),
                          filled: true,
                          // focusColor: Colors.blue,
                          focusColor: Theme.of(context).primaryColor,
                          border: InputBorder.none,
                          fillColor: Theme.of(context).canvasColor,
                        ),
                      ),
                      suggestionsCallback: _suggestionsCallback,
                      itemBuilder: (context, itemData) {
                        print(itemData);
                        return ListTile(
                          title: Text('$itemData'),
                        );
                      },
                      onSuggestionSelected: (value) {
                        countryController.text = value as String;
                      })),
            ],
          ),
          Divider(
            thickness: 0.87,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Icon(Icons.vpn_key),
              ),
              Expanded(
                child: TextField(
                  controller: codeController,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Код товара',
                  ),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 0.87,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Icon(Icons.money),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    maxLines: null,
                    decoration: InputDecoration(
                      suffixText: 'руб',
                      border: InputBorder.none,
                      hintText: 'Цена',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
