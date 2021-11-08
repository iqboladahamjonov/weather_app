import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:weather_app/auth/application/auth/auth_bloc.dart';
import 'package:weather_app/auth/application/sign_in/sign_in_cubit.dart';
import 'package:weather_app/auth/domain/account.dart';
import 'package:weather_app/auth/presentation/login_page.dart';
import 'package:weather_app/settings/presentation/settings_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

class NavigationDrawerWidget extends StatelessWidget {
  final Account? account;
  const NavigationDrawerWidget({required this.account, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Drawer(
      child: ListView(
        children: [
          account != null
              ? _buildHeader(
                  name: account!.username,
                  email: account!.email ?? '',
                  imageUrl: account!.photo,
                  // onClicked: () => Get.to(ProfilePage(name: name, urlImage: urlImage)),
                )
              : Container(),
          const SizedBox(height: 30),
          Column(
            children: [
              Text(t.languageChoice),
              LocaleChoiceWidget(t: t),
            ],
          ),
          const SizedBox(height: 30),
          Divider(color: Colors.blueGrey.shade200),
          const SizedBox(height: 30),
          account != null
              ? ElevatedButton(
                  onPressed: () {
                    context.read<SignInCubit>().logout();
                    Get.off(() => LoginPage());
                  },
                  child: Text(
                    t.logout,
                    style: const TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white70, onPrimary: Colors.black, minimumSize: Size(double.infinity, 50)),
                )
              : ElevatedButton(
                  onPressed: () {
                    Get.off(() => const LoginPage());
                  },
                  child: Text(
                    t.signInWithAccount,
                    style: const TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white70, onPrimary: Colors.black, minimumSize: Size(double.infinity, 50)),
                ),
        ],
      ),
    );
  }
}

Widget _buildHeader({
  required String name,
  required String email,
  String? imageUrl,
  VoidCallback? onClicked,
}) =>
    DrawerHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageUrl != null
              ? CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(imageUrl),
                )
              : CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.yellow,
                  child: Text(
                    name[0],
                    style: TextStyle(fontSize: 40),
                  ),
                ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(fontSize: 18, color: Colors.black)),
              // InkWell(
              //   onTap: onClicked,
              //   child: Icon(Icons.manage_accounts),
              // )
            ],
          ),
          const SizedBox(height: 4),
          Text(email, style: TextStyle(fontSize: 12, color: Colors.black)),
          const Spacer(),
        ],
      ),
    );
