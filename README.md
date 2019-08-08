一个简易版极光Push SDK的Flutter插件，支持接收Push消息。


使用方法：

```
dependencies:
  flutter_push_plugin:
    git:
      url: https://github.com/cyndibaby905/31_flutter_push_plugin.git
```

配置极光App：

新增一个极光App配置，分别把android app的包名，iOS app的bundleID设置为对应的应用信息。其中Android的包名可以在android目录下AndroidMenifest.xml文件中找到；iOS的bundleID可以在iOS目录下打开`Runner.xcworkspace`，在工程面板中的Identity中找到。


Dart：

```
FlutterPushPlugin fpush = new FlutterPushPlugin();
//注册appid
fpush.setupWithAppID("your app id");
//接收消息
fpush.setOpenNotificationHandler((String message) {
  print("Received: $message");
});
//获取RegID
String regID = await fpush.registrationID;

```

Android：

在android目录下App的`build.gradle`文件中增加下列代码，配置AppID：

```
 defaultConfig {
     ...
     ndk {
         abiFilters 'armeabi', 'armeabi-v7a', 'arm64-v8a'
    }

    manifestPlaceholders = [
        JPUSH_PKGNAME : applicationId,
        JPUSH_APPKEY : "your app id",
        JPUSH_CHANNEL : "developer-default",
    ]
}
```

iOS：

修改应用最低支持版本：在iOS目录下的Podfile文件，修改文件头，将应用最低支持版本修改为10.0：

```
platform :ios, '10.0'
```
然后通过控制台进入iOS目录，输入命令`pod install`，等依赖构建结束后，打开`Runner.xcworkspace`文件：

1.启动Push：选择Runner工程，开启Application Target 的 Capabilities->Push Notifications选项；

2.支持HTTP传输：在App项目的plist中，手动配置下key和值以支持 http传输：

```
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```
3.设置plist中bundle ID：在App项目的plist中，手动把Bundle identifier项同步为刚才在JPush控制台的注册的bundle id填写进去。




