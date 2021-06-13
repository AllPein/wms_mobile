import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wms_mobile/domain/blocs/authentication/authentication_cubit.dart';
import 'package:wms_mobile/domain/blocs/cubit/loading_cubit.dart';
import 'package:wms_mobile/domain/repositories/authentication.dart';
import 'package:wms_mobile/domain/repositories/user.dart';
import 'package:wms_mobile/domain/services/api.dart';
import 'package:wms_mobile/modules/home/view/home_view.dart';
import 'package:wms_mobile/modules/login/view/view.dart';
import 'package:wms_mobile/observer.dart';

import 'domain/services/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = Observer();
  Jiffy.locale('ru');
  GetIt.I.registerSingleton(await Storage().init());
  GetIt.I.registerSingleton(Api());
  runApp(App(
    authenticationRepository: AuthenticationRepository(),
  ));
}

class App extends StatelessWidget {
  const App({Key? key, required this.authenticationRepository})
      : super(key: key);

  final AuthenticationRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (context) => AuthenticationCubit(
            authenticationRepository: authenticationRepository,
            userRepository: UserRepository()),
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoadingCubit(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          title: 'Flutter Demo',
          theme: ThemeData(
            backgroundColor: Color(0xffbbdefb),
            primarySwatch: Colors.blue,
          ),
          builder: (context, child) {
            return BlocListener<AuthenticationCubit, AuthenticationState>(
                listener: (context, state) {
                  print(state);
                  switch (state.status) {
                    case AuthenticationStatus.authenticated:
                      _navigator.pushAndRemoveUntil<void>(
                        HomePage.route(),
                        (route) => false,
                      );
                      break;
                    case AuthenticationStatus.unauthenticated:
                      _navigator.pushAndRemoveUntil<void>(
                        LoginPage.route(),
                        (route) => false,
                      );
                      break;
                    default:
                      _navigator.pushAndRemoveUntil<void>(
                        LoginPage.route(),
                        (route) => false,
                      );
                      break;
                  }
                },
                child: child!);
          },
          onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ))),
    );
  }
}
