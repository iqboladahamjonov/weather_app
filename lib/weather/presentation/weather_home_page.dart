import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:weather_app/auth/application/auth/auth_bloc.dart';
import 'package:weather_app/auth/application/sign_in/sign_in_cubit.dart';
import 'package:weather_app/auth/domain/account.dart';
import 'package:weather_app/auth/presentation/login_page.dart';
import 'package:weather_app/settings/presentation/settings_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:weather_app/weather/presentation/widgets/navigation_drawer_widget.dart';

class WeatherHomePage extends StatelessWidget {
  final Account? account;
  const WeatherHomePage({this.account, key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is NotAuthenticated) {
          Get.off(() => LoginPage());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Weather Home Page'),
        ),
        drawer: NavigationDrawerWidget(account: account ?? null),
        body: Center(child: account != null ? Text('Hello ${account!.username}') : Text('hello')),
      ),
    );
  }
}
