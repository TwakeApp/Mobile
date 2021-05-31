import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:lottie/lottie.dart';
import 'package:twake/blocs_new/authentication_cubit/authentication_cubit.dart';
import 'package:twake/config/dimensions_config.dart';
import 'package:twake/pages/auth_page.dart';
import 'package:twake/pages/routes.dart';
import 'package:twake/pages/web_auth_page.dart';
import 'package:twake/services/init_service.dart';
import 'package:twake/widgets/auth/auth_form.dart';
import 'package:twake/widgets/common/network_status_bar.dart';

class InitialPage extends StatefulWidget {
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    //  final authenticationCubitState = BlocProvider.of<AuthenticationCubit>(context).state;
    //  print(authenticationCubitState);
  }

  Widget buildSplashScreen() {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: Dim.heightPercent(13),
          height: Dim.heightPercent(13),
          child: Lottie.asset(
            'assets/animations/splash.json',
            animate: true,
            repeat: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authenticationCubit = BlocProvider.of<AuthenticationCubit>(context);
    if (!kDebugMode) Segment.screen(screenName: 'Initial screen');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (ctx, state) {
          // print("BUILDING INITIAL PAGE");
          if (state is AuthenticationInProgress) {
            return Text("InProgress");
            // buildSplashScreen();
          }
          if (state is AuthenticationInitial) {
            return InkWell(
              child: Center(
                child: Text("Initial"),
              ),
              onTap: () {
                authenticationCubit.authenticate(
                    username: 'testbot', password: '12345678');
              },
            );
            // AuthForm();
          }
          if (state is AuthenticationSuccess) {
            return Text("Authenticated",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40));
          } else {
            return buildSplashScreen();
          }
        },
      ),
    );
  }
}
