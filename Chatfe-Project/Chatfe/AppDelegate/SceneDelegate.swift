//
//  SceneDelegate.swift
//  Chatfe
//
//  Created by Piyush Mohan on 18/04/22.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        _ = UserDefaultUtility.shared.getUserId()
        if UserDefaultUtility.shared.getUserId() != nil && UserDefaultUtility.shared.getUserId() != "" {
//            let tabBarVC = kHomeStoryboard.instantiateViewController(withIdentifier: MainTabBarController.className) as! MainTabBarController
            let tabBarVC = kHomeStoryboard.instantiateViewController(withIdentifier: "MainContainerVC")
//
            let nav = UINavigationController(rootViewController: tabBarVC)
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
        } else if UserDefaultUtility.shared.getUserId() == "" || UserDefaultUtility.shared.getUserId() == nil {
            let welcomeVC = kMainStoryboard.instantiateViewController(withIdentifier: SignInViewController.className) as! SignInViewController
            let nav = UINavigationController(rootViewController: welcomeVC)
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        SocketIOManager.shared.reConnect()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        if !SocketIOManager.shared.isSocketConnected() {
            SocketIOManager.shared.reConnect()
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        // (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
//        SocketIOManager.shared.closeConnection()
        PersistentStorage.shared.saveContext()
    }
    
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        // DEEP LINKING
        URLContexts.forEach { context in
            if let scheme = context.url.scheme, scheme.localizedCaseInsensitiveContains("chatfe") {
                if let host = context.url.host, host.count > 1 {
                    let id = context.url.host
                    let data = ["roomId": id]
                    NotificationCenter.default.post(name: NSNotification.Name.DeepLinkNotification, object: data)
                }
            }
        }
        
        guard let url = URLContexts.first?.url else {
            return
        }
        ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: [UIApplication.OpenURLOptionsKey.annotation])
    }
    
}
