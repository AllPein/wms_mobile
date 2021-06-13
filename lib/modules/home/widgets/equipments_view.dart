import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms_mobile/modules/home/cubit/home_cubit.dart';

class EquipmentView extends StatelessWidget {
  const EquipmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      if (state is HomeLoading) {
        return CircularProgressIndicator();
      }
      if (state is HomeLoaded) {
        return ListView.builder(
          itemCount: state.equipments.length,
          itemBuilder: (context, index) {
            final equipment = state.equipments[index];
            return ListTile(
              title: Text(equipment.name),
              subtitle: Text(equipment.code),
            );
          },
        );
      }
      return Container();
    });
  }
}
