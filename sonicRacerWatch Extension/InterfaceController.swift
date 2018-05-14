//  InterfaceController.swift
//  sonicRacerWatch Extension
//
//  Created by David Butler on 4/28/17.
//  Copyright © 2017 DHBWorlds. All rights reserved.
//

import AVFoundation
import Foundation
import WatchKit

class InterfaceController: WKInterfaceController, WKCrownDelegate {
    @IBOutlet weak var skInterface: WKInterfaceSKScene!
    //-(IBAction) handlePan: (WKPanGestureRecognizer*) panGesture;
    //@property IBAction WKPanGestureRecognizer *handlePan;
    var panGesture: WKPanGestureRecognizer?
    var tapGesture: WKTapGestureRecognizer?
    var backgroundMusicPlayer: AVAudioPlayer?

    @IBAction func panGesture(_ sender: Any) {
        var loc: CGPoint
        let panGest: WKPanGestureRecognizer? = (sender as? WKPanGestureRecognizer)
        var gameScene: GameScene?
        switch panGest!.state {
            case .possible:
                break
            case .began:
                loc = panGest!.locationInObject()
                gameScene = (skInterface.scene as? GameScene)
                gameScene?.moveImage(forTouches: loc)
            case .changed:
                loc = panGest!.locationInObject()
                gameScene = (skInterface.scene as? GameScene)
                gameScene?.moveImage(forTouches: loc)
            case .ended:
                loc = panGest!.locationInObject()
                gameScene = (skInterface.scene as? GameScene)
                gameScene?.moveImage(forTouches: loc)
            case .cancelled:
                break
            case .failed:
                break
            case .recognized:
                loc = panGest!.locationInObject()
                gameScene = (skInterface.scene as? GameScene)
                gameScene?.moveImage(forTouches: loc)
        }

    }

    @IBAction func tapGesture(_ sender: Any) {
        var loc: CGPoint
        let tapGest: WKTapGestureRecognizer? = (sender as? WKTapGestureRecognizer)
        var gameScene: GameScene?
        switch tapGest!.state {
            case .possible:
                break
            case .began:
                loc = (tapGest?.locationInObject())!
                gameScene = (skInterface.scene as? GameScene)
                gameScene?.moveImage(forTouches: loc)
            case .changed:
                loc = (tapGest?.locationInObject())!
                gameScene = (skInterface.scene as? GameScene)
                gameScene?.moveImage(forTouches: loc)
            case .ended:
                loc = (tapGest?.locationInObject())!
                gameScene = (skInterface.scene as? GameScene)
                gameScene?.moveImage(forTouches: loc)
            case .cancelled:
                break
            case .failed:
                break
            case .recognized:
                loc = tapGest!.locationInObject()
                gameScene = (skInterface.scene as? GameScene)
                gameScene?.moveImage(forTouches: loc)
        }

    }

    override func awake(withContext context: (Any)?) {
        super.awake(withContext: context)
        // Dont play music on Watch1.  Perf issues
        if !isWatch1() {
                // Load the SKScene from 'GameScene.sks'
                //Setup the rolling sound
            var error: Error?
            let backgroundMusicURL: URL! = Bundle.main.url(forResource: "Sonic Racer", withExtension: "m4a")
            backgroundMusicPlayer = try! AVAudioPlayer(contentsOf: backgroundMusicURL)
            backgroundMusicPlayer?.numberOfLoops = -1
            backgroundMusicPlayer?.volume = 0.5
            backgroundMusicPlayer?.prepareToPlay()
        }
        print("Current device is: \(userDeviceName())")
            //GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
        let scene = GameScene(size: ScaleUtil.getSceneSize())
        scene.skInterfaceRef = skInterface
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        // Present the scene
        skInterface.presentScene(scene)
        // Use a value that will maintain consistent frame rate
        skInterface.preferredFramesPerSecond = 60
        crownSequencer.delegate = self
        crownSequencer.focus()
    }

    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        var gameScene: GameScene?
        gameScene = (skInterface.scene as? GameScene)
        gameScene?.moveImage(forCrown: rotationalDelta)
    }

    override func didAppear() {
        // This method is called when watch view controller is no longer visible
        super.didAppear()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        //Pause Sound
        if backgroundMusicPlayer != nil {
            backgroundMusicPlayer?.play()
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        //Pause Sound
        if backgroundMusicPlayer != nil {
            backgroundMusicPlayer?.pause()
        }
    }

    func isWatch1() -> Bool {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0,  count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        
        let platform = String(cString: machine)

        if ((platform as? NSString)?.substring(to: 6) == "Watch1") {
            return true
        }
        return false
    }

    func userDeviceName() -> String {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0,  count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        
        let platform = String(cString: machine)
        
        //iPhone
        if (platform == "iPhone1,1") {
            return "iPhone (1st generation)"
        }
        if (platform == "iPhone1,2") {
            return "iPhone 3G"
        }
        if (platform == "iPhone2,1") {
            return "iPhone 3GS"
        }
        if (platform == "iPhone3,1") {
            return "iPhone 4 (GSM)"
        }
        if (platform == "iPhone3,2") {
            return "iPhone 4 (GSM, 2nd revision)"
        }
        if (platform == "iPhone3,3") {
            return "iPhone 4 (Verizon)"
        }
        if (platform == "iPhone4,1") {
            return "iPhone 4S"
        }
        if (platform == "iPhone5,1") {
            return "iPhone 5 (GSM)"
        }
        if (platform == "iPhone5,2") {
            return "iPhone 5 (GSM+CDMA)"
        }
        if (platform == "iPhone5,3") {
            return "iPhone 5c (GSM)"
        }
        if (platform == "iPhone5,4") {
            return "iPhone 5c (GSM+CDMA)"
        }
        if (platform == "iPhone6,1") {
            return "iPhone 5s (GSM)"
        }
        if (platform == "iPhone6,2") {
            return "iPhone 5s (GSM+CDMA)"
        }
        if (platform == "iPhone7,2") {
            return "iPhone 6"
        }
        if (platform == "iPhone7,1") {
            return "iPhone 6 Plus"
        }
        if (platform == "iPhone8,1") {
            return "iPhone 6s"
        }
        if (platform == "iPhone8,2") {
            return "iPhone 6s Plus"
        }
        if (platform == "iPhone8,4") {
            return "iPhone SE"
        }
        if (platform == "iPhone9,1") {
            return "iPhone 7 (GSM+CDMA)"
        }
        if (platform == "iPhone9,3") {
            return "iPhone 7 (GSM)"
        }
        if (platform == "iPhone9,2") {
            return "iPhone 7 Plus (GSM+CDMA)"
        }
        if (platform == "iPhone9,4") {
            return "iPhone 7 Plus (GSM)"
        }
        //iPod Touch
        if (platform == "iPod1,1") {
            return "iPod Touch 1G"
        }
        if (platform == "iPod2,1") {
            return "iPod Touch 2G"
        }
        if (platform == "iPod3,1") {
            return "iPod Touch 3G"
        }
        if (platform == "iPod4,1") {
            return "iPod Touch 4G"
        }
        if (platform == "iPod5,1") {
            return "iPod Touch 5G"
        }
        if (platform == "iPod7,1") {
            return "iPod Touch 6G"
        }
        //iPad
        if (platform == "iPad1,1") {
            return "iPad (1st generation)"
        }
        if (platform == "iPad2,1") {
            return "iPad 2 (Wi-Fi)"
        }
        if (platform == "iPad2,2") {
            return "iPad 2 (GSM)"
        }
        if (platform == "iPad2,3") {
            return "iPad 2 (CDMA)"
        }
        if (platform == "iPad2,4") {
            return "iPad 2 (Wi-Fi, Mid 2012)"
        }
        if (platform == "iPad2,5") {
            return "iPad Mini (Wi-Fi)"
        }
        if (platform == "iPad2,6") {
            return "iPad Mini (GSM)"
        }
        if (platform == "iPad2,7") {
            return "iPad Mini (GSM+CDMA)"
        }
        if (platform == "iPad3,1") {
            return "iPad (3rd generation) (Wi-Fi)"
        }
        if (platform == "iPad3,2") {
            return "iPad (3rd generation) (GSM+CDMA)"
        }
        if (platform == "iPad3,3") {
            return "iPad (3rd generation) (GSM)"
        }
        if (platform == "iPad3,4") {
            return "iPad (4th generation) (Wi-Fi)"
        }
        if (platform == "iPad3,5") {
            return "iPad (4th generation) (GSM)"
        }
        if (platform == "iPad3,6") {
            return "iPad (4th generation) (GSM+CDMA)"
        }
        if (platform == "iPad4,1") {
            return "iPad Air (Wi-Fi)"
        }
        if (platform == "iPad4,2") {
            return "iPad Air (Cellular)"
        }
        if (platform == "iPad4,3") {
            return "iPad Air (China)"
        }
        if (platform == "iPad4,4") {
            return "iPad Mini 2 (Wi-Fi)"
        }
        if (platform == "iPad4,5") {
            return "iPad Mini 2 (Cellular)"
        }
        if (platform == "iPad4,6") {
            return "iPad Mini 2 (China)"
        }
        if (platform == "iPad4,7") {
            return "iPad Mini 3 (Wi-Fi)"
        }
        if (platform == "iPad4,8") {
            return "iPad Mini 3 (Cellular)"
        }
        if (platform == "iPad4,9") {
            return "iPad Mini 3 (China)"
        }
        if (platform == "iPad5,1") {
            return "iPad Mini 4 (Wi-Fi)"
        }
        if (platform == "iPad5,2") {
            return "iPad Mini 4 (Cellular)"
        }
        if (platform == "iPad5,3") {
            return "iPad Air 2 (Wi-Fi)"
        }
        if (platform == "iPad5,4") {
            return "iPad Air 2 (Cellular)"
        }
        if (platform == "iPad6,3") {
            return "iPad Pro 9.7\" (Wi-Fi)"
        }
        if (platform == "iPad6,4") {
            return "iPad Pro 9.7\" (Cellular)"
        }
        if (platform == "iPad6,7") {
            return "iPad Pro 12.9\" (Wi-Fi)"
        }
        if (platform == "iPad6,8") {
            return "iPad Pro 12.9\" (Cellular)"
        }
        if (platform == "iPad6,11") {
            return "iPad (5th generation) (Wi-Fi)"
        }
        if (platform == "iPad6,12") {
            return "iPad (5th generation) (Cellular)"
        }
        if (platform == "iPad7,1") {
            return "iPad Pro 12.9\" (2nd generation) (Wi-Fi)"
        }
        if (platform == "iPad7,2") {
            return "iPad Pro 12.9\" (2nd generation) (Cellular)"
        }
        if (platform == "iPad7,3") {
            return "iPad Pro 10.5\" (Wi-Fi)"
        }
        if (platform == "iPad7,4") {
            return "iPad Pro 10.5\" (Cellular)"
        }
        //Apple TV
        if (platform == "AppleTV2,1") {
            return "Apple TV 2G"
        }
        if (platform == "AppleTV3,1") {
            return "Apple TV 3"
        }
        if (platform == "AppleTV3,2") {
            return "Apple TV 3 (2013)"
        }
        if (platform == "AppleTV5,3") {
            return "Apple TV 4"
        }
        //Apple Watch
        if (platform == "Watch1,1") {
            return "Apple Watch (1st generation) (38mm, S1)"
        }
        if (platform == "Watch1,2") {
            return "Apple Watch (1st generation) (42mm, S1)"
        }
        if (platform == "Watch2,6") {
            return "Apple Watch Series 1 (38mm, S1P)"
        }
        if (platform == "Watch2,7") {
            return "Apple Watch Series 1 (42mm, S1P)"
        }
        if (platform == "Watch2,3") {
            return "Apple Watch Series 2 (38mm, S2)"
        }
        if (platform == "Watch2,4") {
            return "Apple Watch Series 2 (42mm, S2)"
        }
        //Simulator
        if (platform == "i386") {
            return "Simulator"
        }
        if (platform == "x86_64") {
            return "Simulator"
        }
        return platform
    }
}
