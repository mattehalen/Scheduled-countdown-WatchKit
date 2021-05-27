//
//  AppDelegate.swift
//  Scheduled-countdown
//
//  Created by Administrator on 2021-03-02.
//  Copyright © 2021 Mathias Halén. All rights reserved.
//

import UIKit
import SocketIO

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    //-------------------------------
    func registerDefaultsFromSettingsBundle()
    {
        let settingsUrl = Bundle.main.url(forResource: "Settings", withExtension: "bundle")!.appendingPathComponent("Root.plist")
        let settingsPlist = NSDictionary(contentsOf:settingsUrl)!
        let preferences = settingsPlist["PreferenceSpecifiers"] as! [NSDictionary]
        
        var defaultsToRegister = Dictionary<String, Any>()
        
        for preference in preferences {
            guard let key = preference["Key"] as? String else {
                NSLog("Key not found")
                continue
            }
            defaultsToRegister[key] = preference["DefaultValue"]
        }
        UserDefaults.standard.register(defaults: defaultsToRegister)
    }
    //-------------------------------
    func applicationDidEnterBackground(_ application: UIApplication) {
        SocketIOManager.sharedInstance.closeConnection()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        SocketIOManager.sharedInstance.establishConnection()
    }
    //-------------------------------
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerDefaultsFromSettingsBundle()
        SocketIOManager.sharedInstance.establishConnection()
        UIApplication.shared.registerForRemoteNotifications()
        return true
    }
    //----------------------------------------------------------------------------------------------------
    func application(_ application: UIApplication,
                didRegisterForRemoteNotificationsWithDeviceToken
                    deviceToken: Data) {
        print("-----> didRegisterForRemoteNotificationsWithDeviceToken")
//        print(UIDevice.current.name)
//        print(UIDevice.current.model)
        
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            SocketIOManager.sharedInstance.emit(message: ["type":"deviceToken","message":["token":"\(deviceTokenString))","deviceName":UIDevice.current.name,"deviceModel":UIDevice.current.model]])
            print(deviceTokenString)
        })
        
        


        }
    func application(_ application: UIApplication,
                didFailToRegisterForRemoteNotificationsWithError
                    error: Error) {
       // Try again later.
        print("-----> didFailToRegisterForRemoteNotificationsWithError")
        print(error)
        
    }
    

    //----------------------------------------------------------------------------------------------------

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

