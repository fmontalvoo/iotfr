import 'package:flutter/material.dart';
import 'package:iotfr_app/pages/history_page.dart';

import 'package:iotfr_app/providers/fcm_provider.dart';

import 'package:iotfr_app/pages/home_page.dart';
import 'package:iotfr_app/pages/login_page.dart';
import 'package:iotfr_app/pages/user_page.dart';
import 'package:iotfr_app/pages/user_list_page.dart';
import 'package:iotfr_app/pages/face_register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    final fcmProvider = FCMProvider();
    fcmProvider.initNotifications();
    fcmProvider.getNotificationsStream.listen((message) {
      _navigatorKey.currentState.pushNamed('history', arguments: message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'IOTFR',
      theme: ThemeData(
        primarySwatch: MaterialColor(
          0xFF3B343D,
          <int, Color>{
            50: Color(0xFF3B343D),
            100: Color(0xFF3B343D),
            200: Color(0xFF3B343D),
            300: Color(0xFF3B343D),
            400: Color(0xFF3B343D),
            500: Color(0xFF3B343D),
            600: Color(0xFF3B343D),
            700: Color(0xFF3B343D),
            800: Color(0xFF3B343D),
            900: Color(0xFF3B343D),
          },
        ),
      ),
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginPage(),
        'home': (contex) => HomePage(),
        'users': (context) => UserListPage(),
        'user': (context) => UserPage(),
        'face': (context) => FaceRegisterPage(),
        'history': (context) => HistoryPage(),
      },
    );
  }
}
