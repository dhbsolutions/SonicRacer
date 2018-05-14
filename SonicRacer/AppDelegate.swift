//  AppDelegate.swift
//  SonicRacer
//
//  Created by Dave Butler on 6/10/14.
//  Copyright (c) 2014 Dave Butler. All rights reserved.
//

import AudioToolbox
import GameKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var sharedActions: SharedAction?
    var lastScore: Int = 0
    var gamesPlayed: Int = 0
    var isGameCenterAuthenticationComplete: Bool = false
    // currentPlayerID is the value of the playerID last time GameKit authenticated.
    var currentPlayerID: String = ""
    var score: GKScore?

    func submitScore() {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            score = GKScore(leaderboardIdentifier: "com.DHBWorlds.SonicRacer")
            score?.value = Int64(lastScore)
            GKScore.report([score!], withCompletionHandler: {(_ error: Error?) -> Void in
                if error != nil {
                    print("error: \(String(describing: error))")
                }
            })
        }
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil)
        -> Bool {
        
        // Override point for customization after application launch.
        gamesPlayed = 0
        isGameCenterAuthenticationComplete = false
        //weak var localPlayer = GKLocalPlayer.localPlayer()
        /*
             The authenticateWithCompletionHandler method is like all completion handler methods and runs a block
             of code after completing its task. The difference with this method is that it does not release the 
             completion handler after calling it. Whenever your application returns to the foreground after 
             running in the background, Game Kit re-authenticates the user and calls the retained completion 
             handler. This means the authenticateWithCompletionHandler: method only needs to be called once each 
             time your application is launched. This is the reason the sample authenticates in the application 
             delegate's application:didFinishLaunchingWithOptions: method instead of in the view controller's 
             viewDidLoad method.
             
             Remember this call returns immediately, before the user is authenticated. This is because it uses 
             Grand Central Dispatch to call the block asynchronously once authentication completes.
             */
           /* localPlayer?.authenticateHandler = {(_ loginVC: UIViewController, _ error: Error?) -> Void in
            // If there is an error, do not assume local player is not authenticated. 
            if GKLocalPlayer.localPlayer().isAuthenticated {
                // Enable Game Center Functionality 
                self.isGameCenterAuthenticationComplete = true
                // Current playerID has changed. Create/Load a game state around the new user.
                self.currentPlayerID = (localPlayer?.playerID!)!
            }
            else if loginVC != nil {
                // no one is logged into GC so present the login dialog
                self.window?.rootViewController?.present(loginVC, animated: true, completion: {(_: Void) -> Void in
                    if GKLocalPlayer.localPlayer().isAuthenticated {
                        // Enable Game Center Functionality 
                        self.isGameCenterAuthenticationComplete = true
                    }
                    else {
                        self.isGameCenterAuthenticationComplete = false
                    }
                })
                // No user is logged into Game Center, run without Game Center support or user interface.
                self.isGameCenterAuthenticationComplete = false
            }
            else {
                self.isGameCenterAuthenticationComplete = false
                //            [self disableGameCenter];
            }

        } as! (UIViewController?, Error?) -> Void */
            
        UIApplication.shared.setStatusBarHidden(true, with: .slide)
        sharedActions = SharedAction()
        sharedActions?.loadSharedAssets()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UIApplication.shared.isIdleTimerDisabled = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.isIdleTimerDisabled = true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //- (void) reportHighScore:(NSInteger) highScore forLeaderboardId:(NSString*) leaderboardId {
    func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
        
        var reply = reply
            /*
                 Because this method is likely to be called when the app is in the
                 background, begin a background task. Starting a background task ensures
                 that your app is not suspended before it has a chance to send its reply.
                 */
        var identifier: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
            // The "endBlock" ensures that the background task is ended and the identifier is reset.
        let endBlock: () -> () = {() -> Void in
                if identifier != UIBackgroundTaskInvalid {
                    application.endBackgroundTask(identifier)
                }
                identifier = UIBackgroundTaskInvalid
            }
        identifier = application.beginBackgroundTask(expirationHandler: endBlock)
        // Re-assign the "reply" block to include a call to "endBlock" after "reply" is called.
        reply = {(_ replyInfo: [AnyHashable: Any]) -> Void in
            reply(replyInfo)
            // This dispatch_after of 2 seconds is only needed on iOS 8.2. On iOS 8.3+, it is not needed. You can call endBlock() by itself.
            DispatchQueue.global(qos: .default).asyncAfter(deadline: DispatchTime.now() + Double((ino64_t)(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
                endBlock()
            })
        } as! ([AnyHashable : Any]?) -> Void
        // Receives text input result from the WatchKit app extension.
        print("User Info: \(String(describing: userInfo))")
        // Sends a confirmation message to the WatchKit app extension that the text input result was received.
        reply(["Confirmation": "Text was received."])
    }
}
