//
//  AppDelegate.swift
//  Chatfe
//
//  Created by Piyush Mohan on 18/04/22.
//

import UIKit
import CoreData
import IQKeyboardManager
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import Firebase
import FirebaseCore
import FirebaseMessaging
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var badgeCount: Int = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // KEYBOARD HANDLER LIBRARY
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().previousNextDisplayMode = .alwaysHide
//        IQKeyboardManager.shared().enabledDistanceHandlingClasses.add(ChatViewController.self)
        IQKeyboardManager.shared().disabledDistanceHandlingClasses.add(ChatViewController.self)
        IQKeyboardManager.shared().disabledToolbarClasses.add(ChatViewController.self)
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        registerForNotification()
//        UIApplication.shared.applicationIconBadgeNumber = 0
       
        /// INITIALIZING GOOGLE ADs
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // GIDSignIn.sharedInstance.clientID = "1042646389750-o5np5bibm88t453d8lam3chn9g34uc7m.apps.googleusercontent.com"
        
        CalendarManager.shared.checkCalendarAccessStatus()
        
        // INITIATING SOCKET CONNECTION
        SocketIOManager.shared.establishConnection()

        /// TABBAR ITEM UNSELECTED IMAGE TINT COLOR
        UITabBar.appearance().unselectedItemTintColor = UIColor("#383D44")
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SocketIOManager.shared.closeConnection()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var flag: Bool = false
        if ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]) {
            // URL Schema for Facebook
            flag = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        } else {
            // URL Schema for Google
            flag = GIDSignIn.sharedInstance.handle(url)
        }
        return flag
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}


extension AppDelegate {
    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    // [START register_for_notifications]
    func registerForNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if error == nil || granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    // [END register_for_notifications]
}


// USER NOTIFICATIONS DELEGATE METHODs
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken
        #if DEBUG
            Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        #else
            Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        #endif
    }
    
    // THIS FUNCTION GETS CALLED - WHEN APP IS IN BACKGROUND
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("\n--> NOTIFICATION USERINFO :> \(userInfo)")
        
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics - by uncommenting below line
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        self.badgeCount += 1
        NotificationCenter.default.post(name: Notification.Name.PUSH_NOTIFICATION_COUNT, object: self.badgeCount)

        completionHandler(.newData)
    }
    
    // THIS FUNCTION GETS CALLED - WHEN APP IS IN FOREGROUND
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        self.badgeCount += 1
        NotificationCenter.default.post(name: Notification.Name.PUSH_NOTIFICATION_COUNT, object: self.badgeCount)

        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        print("\n--> FOREGROUND NOTIFICATION USERINFO :> \(userInfo)")
//        NotificationCenter.default.post(name: Notification.Name("HOME_NOTIFICATION_TAPPED"), object: userInfo["badge"])
        completionHandler([.sound, .badge, .banner])
    }
    
    // THIS FUNCTION GETS CALLED - WHEN TAP ON NOTIFICATION
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        print("\n--> ON TAP! NOTIFICATION USERINFO :> \(userInfo)")
        self.handleTappedNotification(userInfo: userInfo)
        
        completionHandler()
    }
    
    func handleTappedNotification(userInfo: [AnyHashable: Any]) {
        if let type = userInfo[APIKeys.type] as? String, type == Constants.room {
            NotificationCenter.default.post(name: Notification.Name.ROOM_NOTIFICATION_TAPPED, object: userInfo[APIKeys.id])
        } else if let type = userInfo[APIKeys.type] as? String, type == Constants.friendRequest {
            NotificationCenter.default.post(name: Notification.Name.FRIEND_NOTIFICATION_TAPPED, object: userInfo[APIKeys.id])
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("\n--> FAILED TO REGISTER REMOTE NOTIFICATIONS :> \(error.localizedDescription)")
    }
}


// FIREBASE MESSAGING DELEGATE METHODs
extension AppDelegate: MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        AppInstance.shared.deviceToken = fcmToken
        debugPrint("\n--> FCM TOKEN :> \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCM_TOKEN"), object: nil, userInfo: dataDict)
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
}


/*
extension AppDelegate {
    
    /// DEEP LINKING (http://www.chatfe.com/wave_id/episode_id/chapter_index)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.pathComponents.count > 3 {
            let waveId = url.pathComponents[1]
            let episodeId = url.pathComponents[2]
            let chapterIndex = url.pathComponents[3]
            
            let data = ["waveId"        : waveId,
                        "episodeId"     : episodeId,
                        "chapterIndex"  : chapterIndex]
            NotificationCenter.default.post(name: NSNotification.Name.DeepLinkNotification, object: data)
        }
        return true
    }
}


extension AppDelegate {
    
    /// DEEP LINKING (http://www.chatfe.com/room_id)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.pathComponents.count > 1 {
            let id = url.pathComponents[1]
            let data = ["roomId": id]
            NotificationCenter.default.post(name: NSNotification.Name.DeepLinkNotification, object: data)
        }

        return true
    }
}
*/
