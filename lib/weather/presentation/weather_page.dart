import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/auth/application/auth/auth_bloc.dart';
import 'package:weather_app/auth/domain/account.dart';
import 'package:weather_app/auth/presentation/login_page.dart';
import 'package:weather_app/core/domain/fresh.dart';
import 'package:weather_app/core/presentation/toast.dart';
import 'package:weather_app/core/shared/service_locators.dart';
import 'package:weather_app/weather/application/location_cubit/location_cubit.dart';
import 'package:weather_app/weather/application/weather_cubit/weather_cubit.dart';
import 'package:weather_app/weather/domain/weather.dart';
import 'package:weather_app/weather/presentation/widgets/navigation_drawer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WeatherPage extends StatefulWidget {
  final Account? account;
  const WeatherPage({this.account, key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState(account);
}

class _WeatherPageState extends State<WeatherPage> {
  final Account? account;
  int selectedValue = 1;
  _WeatherPageState(this.account);
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<LocationCubit>()),
        BlocProvider(create: (context) => getIt<WeatherCubit>()..getWeather()),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is NotAuthenticated) {
            Get.off(() => LoginPage());
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: BlocBuilder<WeatherCubit, WeatherState>(
              builder: (context, state) {
                return state.maybeWhen(
                  success: (_) => Text(_.entity.location),
                  orElse: () => Text(t.locationLoading),
                );
              },
            ),
            actions: [
              DropdownButton<int>(
                value: selectedValue,
                items: [
                  DropdownMenuItem(
                    child: Text(t.daily),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text(t.hourly),
                    value: 2,
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedValue = value!;
                  });
                },
              )
            ],
          ),
          drawer: NavigationDrawerWidget(account: account ?? null),
          body: MultiBlocListener(
            listeners: [
              BlocListener<LocationCubit, LocationState>(
                listener: (context, state) {
                  state.maybeWhen(
                    failure: (_) {
                      String msg(String failureReason) => t.locationFailureReason;
                      // "As determinig location failed due to , default location as Kiev is being shown";
                      _.when(
                        locationDisabled: (_) => showToast(msg(t.locationDisabled), context), //location disabled
                        denied: (_) => showToast(msg(t.locationDenied), context),
                        deniedForever: (_) => showToast(msg(t.locationPermDisabled), context),
                      );
                    },
                    orElse: () {},
                  );
                },
              ),
              BlocListener<WeatherCubit, WeatherState>(
                listener: (context, state) {
                  state.maybeWhen(
                    success: (weather) {
                      if (weather.isFresh == false) {
                        showToast(t.notOnline, context);
                        //You're not online. Some information may be outdated.
                      }
                    },
                    orElse: () {},
                  );
                },
              ),
            ],
            child: BlocBuilder<WeatherCubit, WeatherState>(builder: (context, state) {
              return state.maybeWhen(
                orElse: () => Container(),
                loading: () => const Center(child: CircularProgressIndicator()),
                failure: (failure) => Text(failure.toString()),
                success: (weather) {
                  if (selectedValue == 1) {
                    return _dailyWeatherInfo(weather);
                  } else {
                    return _hourlyWeatherInfo(weather);
                  }
                },
              );
            }),
          ),
        ),
      ),
    );
  }

  ListView _hourlyWeatherInfo(Fresh<Weather> weather) {
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: weather.entity.hourly.length,
      itemBuilder: (BuildContext context, int index) {
        final hour = weather.entity.hourly[index];
        return Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: Theme.of(context).primaryColor)),
          child: ExpansionTile(
            leading: Column(
              children: [
                Text(DateFormat('EEE').format(hour.hourDateTime)),
                Text(DateFormat('Hm').format(hour.hourDateTime)),
              ],
            ),
            title: Text('${hour.temp.celsius.ceil().toString()}°C'),
            trailing: Column(
              children: [
                Text(hour.weatherInfo[0].main.toString()),
                Icon(Icons.arrow_drop_down_circle_sharp),
              ],
            ),
            children: [
              Text(hour.weatherInfo[0].description.toString()),
              // Text(hour.weatherInfo[0].toString()),
            ],
          ),
        );
      },
    );
  }

  ListView _dailyWeatherInfo(Fresh<Weather> weather) {
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: weather.entity.daily.length,
      itemBuilder: (BuildContext context, int index) {
        final day = weather.entity.daily[index];
        return Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: Theme.of(context).primaryColor)),
          child: ExpansionTile(
            leading: Column(
              children: [
                Text(DateFormat('MMMd').format(day.dayDateTime)),
                Text(DateFormat('EEE').format(day.dayDateTime)),
              ],
            ),
            // key: PageStorageKey(fio),
            title: Text('${day.temp.day.celsius.ceil().toString()}°C'),
            trailing: Column(
              children: [
                Text(day.weatherInfo[0].main.toString()),
                Icon(Icons.arrow_drop_down_circle_sharp),
              ],
            ),
            children: [
              Text(day.weatherInfo[0].description.toString()),
              Text('Humidity - ${day.humidity.toString()}'),
              Text('Windspeed - ${day.windSpeed.toString()}'),
            ],
          ),
        );
      },
    );
  }
}
