import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/route_manager.dart';
import 'package:weather_app/auth/application/auth/auth_bloc.dart';
import 'package:weather_app/auth/application/sign_in/sign_in_cubit.dart';
import 'package:weather_app/core/shared/l10n/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:weather_app/core/shared/service_locators.dart' as di;
import 'package:weather_app/core/shared/service_locators.dart';
import 'package:weather_app/settings/application/locale/locale_cubit.dart';
import 'package:weather_app/splash/presentation/splash_page.dart';
import 'package:weather_app/weather/presentation/weather_home_page.dart';
import 'package:weather_app/weather/presentation/weather_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Splash(),
            debugShowCheckedModeBanner: false,
          );
        } else {
          // Loading is done, return the app:
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => LocaleCubit()),
              BlocProvider(create: (context) => getIt<AuthBloc>()..add(WatchAuthChanges())),
              BlocProvider(create: (context) => getIt<SignInCubit>()),
            ],
            child: BlocBuilder<LocaleCubit, LocaleState>(
              builder: (context, state) {
                return GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'WeatherAppDemo',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  supportedLocales: L10n.all,
                  locale: state.locale,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate
                  ],
                  // home: LoginPage()
                  initialRoute: '/',
                  getPages: [
                    GetPage(
                      name: '/',
                      page: () => WeatherPage(),
                    )
                  ],
                );
              },
            ),
          );
        }
      },
    );
  }
}
