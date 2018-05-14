//  ExtensionDelegate.swift
//  sonicRacerWatch Extension
//
//  Created by David Butler on 4/28/17.
//  Copyright © 2017 DHBWorlds. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task: WKRefreshBackgroundTask in backgroundTasks {
            // Check the Class of each task to decide how to process it
            if (task is WKApplicationRefreshBackgroundTask) {
                    // Be sure to complete the background task once you’re done.
                let backgroundTask: WKApplicationRefreshBackgroundTask? = (task as? WKApplicationRefreshBackgroundTask)
                backgroundTask?.setTaskCompleted()
            }
            else if (task is WKSnapshotRefreshBackgroundTask) {
                    // Snapshot tasks have a unique completion call, make sure to set your expiration date
                let snapshotTask: WKSnapshotRefreshBackgroundTask? = (task as? WKSnapshotRefreshBackgroundTask)
                snapshotTask?.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            }
            else if (task is WKWatchConnectivityRefreshBackgroundTask) {
                    // Be sure to complete the background task once you’re done.
                let backgroundTask: WKWatchConnectivityRefreshBackgroundTask? = (task as? WKWatchConnectivityRefreshBackgroundTask)
                backgroundTask?.setTaskCompleted()
            }
            else if (task is WKURLSessionRefreshBackgroundTask) {
                    // Be sure to complete the background task once you’re done.
                let backgroundTask: WKURLSessionRefreshBackgroundTask? = (task as? WKURLSessionRefreshBackgroundTask)
                backgroundTask?.setTaskCompleted()
            }
            else {
                // make sure to complete unhandled task types
                task.setTaskCompleted()
            }
        }
    }
}
