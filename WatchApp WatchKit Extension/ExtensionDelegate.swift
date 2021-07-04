/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A delegate object for the WatchKit extension that implements the needed life cycle methods.
*/

import ClockKit
import WatchKit
import os

// The app's extension delegate.
class ExtensionDelegate: NSObject, WKExtensionDelegate {
    func applicationDidFinishLaunching(){
        print(">>>>> applicationDidFinishLaunching")
    }
    func applicationDidBecomeActive(){
        print(">>>>>>>>>> applicationDidBecomeActive")
    }
    func applicationWillResignActive(){
        print(">>>>>>>>>>>>>>> applicationWillResignActive")
    }
    func applicationWillEnterForeground(){
        print(">>>>>>>>>>>>>>>>>>>> applicationWillEnterForeground")
    }
    func applicationDidEnterBackground(){
        print(">>>>>>>>>>>>>>>>>>>>>>>>> applicationDidEnterBackground")
        scheduleBackgroundRefreshTasks()
    }
    func updateActiveComplications(){
        
    }


    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        print("__________________________________________________")
        print("Handling a background task...")
        print("App State: \(WKExtension.shared().applicationState.rawValue)")
        print(GlobalVaribles.sharedInstance.currentTime)
        print("__________________________________________________")

        
        for task in backgroundTasks {
            print("backgroundTasks = \(backgroundTasks)")

            switch task {
            // Handle background refresh tasks.
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                scheduleBackgroundRefreshTasks()
                backgroundTask.setTaskCompletedWithSnapshot(true)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
}

func scheduleBackgroundRefreshTasks() {
    print("-->>-->>-->>-->>-->>-->>-->>-->>-->>-->>-->>-->>-->>-->>-->>")
    print(GlobalVaribles.sharedInstance.title)
    print(GlobalVaribles.sharedInstance.currentTime)
    print("-->>-->>-->>-->>-->>-->>-->>-->>-->>-->>-->>-->>-->>-->>-->>")
    let watchExtension = WKExtension.shared()
    let targetDate = Date().addingTimeInterval(60)
    let title = GlobalVaribles.sharedInstance.title
    let time = GlobalVaribles.sharedInstance.time
    let info: NSDictionary = [
        "title" : title,
        "time": time
    ]
    
    watchExtension.scheduleBackgroundRefresh(withPreferredDate: targetDate, userInfo: info) { (error) in
        if let error = error {
            print("An error occurred while scheduling a background refresh task: \(error.localizedDescription)")
            return
        }
        print("Task scheduled with targetDate = \(targetDate).")
    }
}
