//
//  AppDelegate.swift
//  Swift Playground
//
//  Created by Josh Wymer on 1/3/20.
//  Copyright © 2020 Josh Wymer. All rights reserved.
//

import UIKit
import UserNotifications
import Mixpanel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        let mixpanel = Mixpanel.initialize(token: "6888bfdec29d84ab2d36ae18c57b8535")
        mixpanel.identify(distinctId: "josh.wymer@mixpanel.com")
        mixpanel.track(event: "Tracked Event from Swift!")
        mixpanel.people.set(property:"using swift", to:true)
        mixpanel.flush()
        
       UNUserNotificationCenter.current()
          .requestAuthorization(options: [.alert, .sound, .badge]) {
            [weak self] granted, error in
              
            print("Permission granted: \(granted)")
            guard granted else { return }
            
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                print("Notification settings: \(settings)")
                
                guard settings.authorizationStatus == .authorized else { return }
                print("dispatching registerForRemoteNotifications")
                DispatchQueue.main.async {
                  UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        return true
    }
    
    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        let mixpanel = Mixpanel.mainInstance()
        mixpanel.people.addPushDeviceToken(deviceToken)
        mixpanel.flush()
        print("Device Token: \(token)")
    }

    func application(
      _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
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

