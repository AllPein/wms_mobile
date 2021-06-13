import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms_mobile/domain/blocs/cubit/loading_cubit.dart';
import 'package:wms_mobile/domain/models/models.dart';
import 'package:wms_mobile/modules/home/cubit/home_cubit.dart';

class CellsView extends StatelessWidget {
  const CellsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      if (state is HomeLoading) {
        return CircularProgressIndicator();
      }
      if (state is HomeLoaded) {
        final oldContext = context;
        return ListView.builder(
          itemCount: state.cells.length,
          itemBuilder: (context, index) {
            final item = state.cells[index];
            return ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CellDetailView(
                          bloc: oldContext.read<HomeCubit>(),
                          cell: item,
                        )));
              },
              title: Text(item.code),
              subtitle: Text(_parseItemLength(item.items.length)),
            );
          },
        );
      }
      return Container();
    });
  }

  String _parseItemLength(int count) {
    final mod = count % 10;
    if (mod > 10 && mod < 20 || mod == 0) {
      return '$count товаров';
    }
    if (mod == 1) {
      return '$count товар';
    }
    if (mod < 5) {
      return '$count товара';
    }
    return '$count товаров';
  }
}

class CellDetailView extends StatefulWidget {
  const CellDetailView({Key? key, required this.cell, required this.bloc})
      : super(key: key);

  final Cell cell;
  final HomeCubit bloc;

  @override
  _CellDetailViewState createState() => _CellDetailViewState();
}

class _CellDetailViewState extends State<CellDetailView> {
  late Cell _cell;

  @override
  void initState() {
    super.initState();
    _cell = widget.cell;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                widget.cell.code,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Text('Товары в ячейке'),
                Expanded(child: Divider()),
                Hero(
                  tag: 'fab',
                  child: Material(
                      type: MaterialType.transparency,
                      child: RawMaterialButton(
                        onPressed: () async {
                          final res = await showModalBottomSheet<Item>(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            context: context,
                            builder: (context) =>
                                BlocBuilder<HomeCubit, HomeState>(
                              bloc: widget.bloc,
                              builder: (context, state) =>
                                  DraggableScrollableSheet(
                                initialChildSize: 0.5,
                                minChildSize: 0.3,
                                expand: false,
                                maxChildSize: 1,
                                builder: (context, controller) => Container(
                                  color: Colors.transparent,
                                  child: SingleChildScrollView(
                                    controller: controller,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: Column(
                                        children: (state as HomeLoaded)
                                            .items
                                            .where((element) =>
                                                element.cellId !=
                                                widget.cell.id)
                                            .where((element) =>
                                                !_cell.items.contains(element))
                                            .map((e) => ListTile(
                                                  onTap: () {
                                                    Navigator.pop(context, e);
                                                  },
                                                  title: Text(e.name),
                                                  subtitle: Text(e.supplyCode),
                                                  trailing: e.cellId != null
                                                      ? Text(
                                                          state.cells
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      e.cellId)
                                                              .code,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16),
                                                        )
                                                      : null,
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );

                          if (res != null) {
                            context.read<LoadingCubit>().startLoading();
                            await widget.bloc.updateCell(
                                res.copyWith(cellId: widget.cell.id));
                            setState(() {
                              _cell.items.add(res);
                            });
                            context.read<LoadingCubit>().stopLoading();
                          }
                        },
                        elevation: 1,
                        fillColor: Colors.blue,
                        child: BlocBuilder<LoadingCubit, bool>(
                          builder: (context, state) {
                            if (state)
                              return SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              );
                            return Icon(
                              Icons.add,
                              size: 25.0,
                              color: Colors.white,
                            );
                          },
                        ),
                        padding: EdgeInsets.all(12.0),
                        shape: CircleBorder(),
                      )),
                )
              ],
            ),
            ...widget.cell.items.map((e) => ListTile(
                  title: Text(e.name),
                  subtitle: Text(e.supplyCode),
                ))
          ],
        ),
      ),
    );
  }
}
