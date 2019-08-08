import 'dart:async';

import 'package:flutter/services.dart';


typedef Future<dynamic> EventHandler(String event);


class FlutterPushPlugin  {

  factory FlutterPushPlugin() => _instance;

  final MethodChannel _channel;
  EventHandler _onOpenNotification;

  FlutterPushPlugin.private(MethodChannel channel)
      : _channel = channel {
    _channel.setMethodCallHandler(_handleMethod);
  }

  setupWithAppID(String appID) {
    _channel.invokeMethod("setup", appID);
  }

  setOpenNotificationHandler(
    EventHandler onOpenNotification
  ) {
    _onOpenNotification = onOpenNotification;

  }

  Future<Null> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onOpenNotification":
        return _onOpenNotification(call.arguments);
      default:
        throw new UnsupportedError("Unrecognized Event");
    }
  }

  static final FlutterPushPlugin _instance = new FlutterPushPlugin.private(const MethodChannel('flutter_push_plugin'));


  Future<String> get registrationID async {
    final String regID = await _channel.invokeMethod('getRegistrationID');
    return regID;
  }


}
