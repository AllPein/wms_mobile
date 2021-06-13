import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms_mobile/domain/repositories/home.dart';
import 'package:wms_mobile/modules/home/cubit/home_cubit.dart';
import 'package:wms_mobile/modules/home/view/home_page.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute(builder: (context) => HomePage());
  }

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeCubit(HomeRepository())..loadItems(),
        child: HomeView());
  }
}
