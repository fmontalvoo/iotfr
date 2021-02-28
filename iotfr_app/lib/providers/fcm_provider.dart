import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FCMProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _streamController = StreamController<String>.broadcast();
  Stream<String> get getNotificationsStream => _streamController.stream;

  void initNotifications() async {
    _firebaseMessaging.requestNotificationPermissions();
    String token = await _firebaseMessaging.getToken();
    print('TOKEN>> $token');
    final tkn = await getToken();
    if (tkn == null) saveToken(token);

    _firebaseMessaging.configure(
      onMessage: (message) async {
        print('---On_Message>>> $message');
        if (Platform.isAndroid)
          _streamController.sink.add(message['data']['arg'] ?? '');

        if (Platform.isIOS) _streamController.sink.add(message['arg'] ?? '');
      },
      onLaunch: (message) async {
        print('---On_Launch>>> $message');
      },
      onResume: (message) async {
        print('---On_Resume>>> $message');
        if (Platform.isAndroid)
          _streamController.sink.add(message['data']['arg'] ?? '');
        if (Platform.isIOS) _streamController.sink.add(message['arg'] ?? '');
      },
    );
  }

  SharedPreferences _preferences;
  void saveToken(String token) async {
    print(token);
    this._preferences = await SharedPreferences.getInstance();
    this._preferences.setString('fcm_token', token);
  }

  Future<String> getToken() async {
    this._preferences = await SharedPreferences.getInstance();
    return this._preferences.get('fcm_token') ?? null;
  }

  void dispose() {
    _streamController?.close();
  }
}
