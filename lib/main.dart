import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:movietime/screens/dashboard_screen.dart';
import 'package:movietime/screens/no_internet_screen.dart';
import 'package:movietime/utils/app_common.dart';
import 'package:movietime/utils/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'extensions/common.dart';
import 'extensions/system_utils.dart';

final navigatorKey = GlobalKey<NavigatorState>();
late SharedPreferences sharedPreferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static String tag = '/MyApp';

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isCurrentlyOnNoInternet = false;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((e) {
      if (e.contains(ConnectivityResult.none)) {
        log('not connected');
        isCurrentlyOnNoInternet = true;
        push(NoInternetScreen());
      } else {
        if (isCurrentlyOnNoInternet) {
          pop();
          isCurrentlyOnNoInternet = false;
          toast('Internet Is Connected');
        }
        log('connected');
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return MaterialApp(
        title: APP_NAME,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        scrollBehavior: SBehavior(),
        themeMode: ThemeMode.light,
        localeResolutionCallback: (locale, supportedLocales) => locale,
        home: DashboardScreen(),
      );
    });
  }
}
