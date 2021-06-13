import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms_mobile/domain/blocs/authentication/authentication_cubit.dart';
import 'package:wms_mobile/domain/repositories/authentication.dart';
import 'package:wms_mobile/modules/login/cubit/login_cubit.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
      child: LoginForm(),
    );
  }
}
