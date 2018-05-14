//
//
//  ShareAction.h
//  LabyrinthTiltMaze
//
//  Created by Butler, David {BIS} on 4/26/14.
//  Copyright (c) 2014 Dave Butler. All rights reserved.
//
//
//  ShareAction.m
//  Sonic Racer
//
//  Created by Butler, David {BIS} on 4/26/14.
//  Copyright (c) 2014 Dave Butler. All rights reserved.
//

import AVFoundation
import Foundation
import SpriteKit

class SharedAction: NSObject {
    var backgroundMusicPlayer: AVAudioPlayer?
    var isBackgroundMusicPlayerPlaying: Bool = false

    func loadSharedAssets() {
            //Setup the rolling sound
        var error: Error?
        let backgroundMusicURL: URL? = Bundle.main.url(forResource: "Sonic Racer", withExtension: "m4a")
        backgroundMusicPlayer = try? AVAudioPlayer(contentsOf: backgroundMusicURL!)
        backgroundMusicPlayer?.numberOfLoops = -1
        backgroundMusicPlayer?.volume = 0.5
        backgroundMusicPlayer?.prepareToPlay()
        if error != nil {
            print("Error: \(String(describing: error?.localizedDescription))")
        }
    }

    func stopAllSounds() {
        //[self.metalicScrapeSound stop];
        //[self.laserSound pause];
        //[self.electrocutionSound stop];
        //[self.metalicScrapeSound stop];
        //[self.buttonSound stop];*
    }

    func resumeAllSounds() {
        if isBackgroundMusicPlayerPlaying {
            backgroundMusicPlayer?.play()
        }
    }

    func pauseAllSounds() {
        isBackgroundMusicPlayerPlaying = false
        if (backgroundMusicPlayer?.isPlaying)! {
            backgroundMusicPlayer?.pause()
            isBackgroundMusicPlayerPlaying = true
        }
    }
}
