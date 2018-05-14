//  ViewController.h
//  SonicRacer
//
//  Copyright (c) 2014 Dave Butler. All rights reserved.
//
//
//  ViewController.m
//  SonicRacer
//
//  Created by Dave Butler on 6/10/14.
//  Copyright (c) 2014 Dave Butler. All rights reserved.
//

import GameKit
import SpriteKit

class GameSceneViewController: UIViewController, GKGameCenterControllerDelegate {
    var isDidLayoutSubviews: Bool = false
    var scene: GameScene?

    override func viewDidLoad() {

        super.viewDidLoad()
            // Configure the view.
        let skView = view as! SKView
        
            //skView.showsFPS= YES;
            //skView.showsNodeCount = YES;
            //skView.showsDrawCount = YES;
            //skView.showsPhysics=YES;
            // Create and configure the scene.
            scene = GameScene(size: ScaleUtil.getSceneSize())

            // Register to receive notification
            NotificationCenter.default.addObserver(self, selector: #selector(GameSceneViewController.handle), name: NSNotification.Name(rawValue: "presentLeaderboards"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(GameSceneViewController.handle), name: NSNotification.Name(rawValue: "share"), object: nil)
            //self.scene.position = [ScaleUtil positionGameScene];
            scene?.scaleMode = .aspectFill
            //skView?.preferredFramesPerSecond = 60
            //[self.scene setSize: [ScaleUtil getSceneSize]];
            // Present the scene.
            skView.presentScene(scene)
            //view.autoresizesSubviews
                // Play some background music
            let appDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
            appDelegate?.sharedActions?.backgroundMusicPlayer?.play()
        
            self.authenticateLocalPlayer()
    }


  
 
  
    func authenticateLocalPlayer() {
        let appDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)

        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if((viewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(viewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                appDelegate?.isGameCenterAuthenticationComplete = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        print(error ?? "")
                    } else {
                        let identifier: String = leaderboardIdentifer!
                        print(identifier)
                    }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                appDelegate?.isGameCenterAuthenticationComplete = false
                print("Local player could not be authenticated!")
                print(error ?? "")
            }
        }
    }
 


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !isDidLayoutSubviews {
            //self.bannerView = [[[ScaleUtil alloc] init] getADBanner];
            //self.bannerView.delegate=self;
            //[self.bannerView setBackgroundColor:[UIColor clearColor]];
            //[self.view addSubview: self.bannerView];
        }
        isDidLayoutSubviews = true
    }

    override var prefersStatusBarHidden: Bool{
        get{
            return true
        }
    }
    
    override var shouldAutorotate: Bool {
        get{
            return true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

// MARK: -
// MARK:  notifications / buttons pressed
    //Handle Notification
    func handle(withNotification notification : NSNotification) {
        if (notification.name.rawValue == "presentLeaderboards") {
            presentLeaderboards()
        }
        if (notification.name.rawValue == "share") {
            share()
        }
    }

// MARK: Game Center
    @objc public func presentLeaderboards() {
        let gameCenterController = GKGameCenterViewController()
        gameCenterController.viewState = .leaderboards
        gameCenterController.gameCenterDelegate = self
        present(gameCenterController, animated: true, completion: { _ in })
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        dismiss(animated: true, completion: { _ in })
    }

// MARK: Game Center
    func share() {
            // Get the score we want to share
        let appDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
            //Setup the VC with the score
        let string: String? = "I just scored \(Int((appDelegate?.lastScore)!)) pts on Sonic Racer!  Get Sonic Racer NOW and try to beat my score. #SonicRacer\r\r"
        let url = URL(string: "https://itunes.apple.com/app/id894446179")

        
        let activityViewController = UIActivityViewController(activityItems: [string as Any, url as Any], applicationActivities: [])
        present(activityViewController, animated: true)
        
        
        
        //let activityViewController = UIActivityViewController(activityItems: [string, url], applicationActivities: nil)
        //"https://itunes.apple.com/app/id894446179"
        // Dismiss the VC when its done
        /*activityViewController.completionHandler = {(_ activityType: String, _ completed: Bool) -> Void in
            if completed {
                self.dismiss(animated: true, completion: { _ in })
            }
        }*/
        //PResent the VC
        //present(activityViewController, animated: true, completion: { _ in })
    }
}
