import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms_mobile/domain/models/item.dart';
import 'package:wms_mobile/modules/home/cubit/home_cubit.dart';

import 'detail_view.dart';

class ItemsView extends StatelessWidget {
  ItemsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      if (state is HomeLoading) {
        return CircularProgressIndicator();
      }
      if (state is HomeLoaded) {
        final items = state.items;
        return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final oldContext = context;

              return ListTile(
                  onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailView(
                              item: items[index],
                              bloc: BlocProvider.of<HomeCubit>(oldContext)),
                        ),
                      ),
                  title: Text(item.name),
                  subtitle: Text(item.supplyCode),
                  trailing: Container(
                    height: 25,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      mapStatusToText[item.status]!,
                      style: TextStyle(
                        color: mapStatusToColor[item.status],
                      ),
                    ),
                  ));
            });
      }
      return Container();
    });
  }
}
