package com.hangchen.flutter_push_plugin;

import android.util.Log;

import cn.jpush.android.api.JPushInterface;
import cn.jpush.android.api.NotificationMessage;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterPushPlugin */
public class FlutterPushPlugin implements MethodCallHandler {

  public final Registrar registrar;
  private final MethodChannel channel;
  public static FlutterPushPlugin instance;



  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_push_plugin");
    instance = new FlutterPushPlugin(registrar, channel);
    channel.setMethodCallHandler(instance);
    JPushInterface.setDebugMode(true);
    JPushInterface.init(registrar.activity().getApplicationContext());
  }

  private FlutterPushPlugin(Registrar registrar, MethodChannel channel) {
    this.registrar = registrar;
    this.channel = channel;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("setup")) {
      //Do nothing
      result.success(0);
    }
    else if (call.method.equals("getRegistrationID")) {
      result.success(JPushInterface.getRegistrationID(registrar.context()));
    } else {
      result.notImplemented();
    }
  }

  public void callbackNotificationOpened(NotificationMessage message) {
      channel.invokeMethod("onOpenNotification",message.notificationContent);
  }
}
