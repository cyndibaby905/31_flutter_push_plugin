package com.hangchen.flutter_push_plugin;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

import java.util.Timer;
import java.util.TimerTask;

import cn.jpush.android.api.JPushMessage;
import cn.jpush.android.api.NotificationMessage;
import cn.jpush.android.service.JPushMessageReceiver;

public class JPushXMessageReceiver extends JPushMessageReceiver {
    @Override
    public void onNotifyMessageOpened(Context context, final NotificationMessage message) {
        Log.e("Tag","onNotifyMessageOpened");
        try {
            String mainClassName = context.getApplicationContext().getPackageName() + ".MainActivity";
            Intent i = new Intent(context, Class.forName(mainClassName));
            i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP);

            context.startActivity(i);
        } catch (Exception e) {
            Log.e("tag","找不到MainActivity");
        }


        new Timer().schedule(new TimerTask() {
            @Override
            public void run() {
                FlutterPushPlugin.instance.callbackNotificationOpened(message);
            }
        },1000); // 延时1秒



    }

}
