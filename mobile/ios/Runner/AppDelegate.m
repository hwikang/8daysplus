#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

//@import Firebase;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [FIRApp configure];
  [GMSServices provideAPIKey:@"AIzaSyCHUgV2BlmM0_hbjHwac9P6rna2DmC67Ac"];
  [GeneratedPluginRegistrant registerWithRegistry:self];

//  [FIRApp configure];     // 왜 안되징..
//  [FIRMessaging messaging].delegate = self;

//  if (@available(iOS 10.0, *)) {
//    [UNUserNotificationCenter currentNotificationCenter].delegate = (id<UNUserNotificationCenterDelegate>) self;
//  }

  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

// didFailToRegisterForRemoteNotificationsWithError

// - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//     if ([UNUserNotificationCenter class] != nil) {
//       // iOS 10 or later
//       // For iOS 10 display notification (sent via APNS)
//       [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//       UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
//           UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
//       [[UNUserNotificationCenter currentNotificationCenter]
//           requestAuthorizationWithOptions:authOptions
//           completionHandler:^(BOOL granted, NSError * _Nullable error) {
//             // ...
//           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"title" message:@"message" preferredStyle:UIAlertControllerStyleAlert];
//           [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
//           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//               [alert dismissViewControllerAnimated:YES completion:nil];
//           });
//         }];
//     } else {
//       // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
// //      UIUserNotificationType allNotificationTypes =
// //      (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
// //      UIUserNotificationSettings *settings =
// //      [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
// //      [application registerUserNotificationSettings:settings];
//     }

//     [application registerForRemoteNotifications];
// }

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}



@end
