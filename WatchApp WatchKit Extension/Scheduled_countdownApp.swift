//
//  Scheduled_countdownApp.swift
//  WatchApp WatchKit Extension
//
//  Created by Mathias Halén on 2021-06-22.
//  Copyright © 2021 Mathias Halén. All rights reserved.
//

import SwiftUI

@main
struct Scheduled_countdownApp: App {
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var delegate
    //@UIApplicationDelegateAdaptor(ExtensionDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
//        .onChange(of: scenePhase) { phase in
//            switch phase{
//            case .active:
//                print("->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->")
//                print("Active")
//                print("->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->")
//            case .inactive:
//                print("->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->")
//                print("inactive")
//                print("->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->")
//            case .background:
//                print("->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->")
//                print("background")
//                print("->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->")
//            @unknown default:
//                print("something new added by apple")
//            }
//        }
        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}

