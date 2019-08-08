#import "FlutterPushPlugin.h"
#import <JPush/JPUSHService.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface FlutterPushPlugin ()<JPUSHRegisterDelegate>
@property(nonatomic, strong)FlutterMethodChannel *channel;
@property(nonatomic, strong)NSDictionary *launchOptions;
@end


@implementation FlutterPushPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_push_plugin"
            binaryMessenger:[registrar messenger]];
    FlutterPushPlugin* instance = [[FlutterPushPlugin alloc] init];
    instance.channel = channel;
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if([@"setup" isEqualToString:call.method]) {
        [JPUSHService setupWithOption:self.launchOptions appKey:call.arguments
                              channel:@"App Store"
                     apsForProduction:YES
                advertisingIdentifier:nil];
    } else if ([@"getRegistrationID" isEqualToString:call.method]) {
      [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
         result(registrationID);
      }];
    } else {
    result(FlutterMethodNotImplemented);
  }
}


-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    self.launchOptions = launchOptions;
    
    
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}


#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {

    NSLog(@"didReceiveNotificationResponse");

    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *content = userInfo[@"aps"][@"alert"];
        if ([content isKindOfClass:[NSDictionary class]]) {
            content = userInfo[@"aps"][@"alert"][@"body"];
        }
        [self.channel invokeMethod:@"onOpenNotification" arguments:content];
    });
    
    UIApplication.sharedApplication.applicationIconBadgeNumber = 0;

    completionHandler();  // 系统要求执行这个方法
    
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler {
    NSLog(@"willPresentNotification");
    completionHandler(UNNotificationPresentationOptionAlert); 
}




@end
