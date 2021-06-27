/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A delegate object for the WatchKit extension that implements the needed life cycle methods.
*/

import WatchKit
import os

// The app's extension delegate.
class ExtensionDelegate: NSObject, WKExtensionDelegate {
    func applicationDidFinishLaunching(){
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    }
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        print("__________________________________________________")
        print("Handling a background task...")
        print("App State: \(WKExtension.shared().applicationState.rawValue)")
        print("__________________________________________________")

        
        for task in backgroundTasks {
            print("++++++++++++++++++++++++++++++++++++++++++++++++++")
            print("Task: \(task)")
            print("++++++++++++++++++++++++++++++++++++++++++++++++++")

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
    
    
    print("**************************************************")
    print("Scheduling a background task.")
    print("**************************************************")

    let watchExtension = WKExtension.shared()
    let targetDate = Date().addingTimeInterval(3*60)
    
    watchExtension.scheduleBackgroundRefresh(withPreferredDate: targetDate, userInfo: nil) { (error) in
        if let error = error {
            print("An error occurred while scheduling a background refresh task: \(error.localizedDescription)")
            return
        }
        
        print("Task scheduled!")
    }
}
