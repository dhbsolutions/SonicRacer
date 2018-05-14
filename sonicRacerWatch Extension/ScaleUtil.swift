//  ScaleUtil.swift
//  SonicRacer
//
//  Created by Butler, David {BIS} on 3/12/14.
//  Copyright (c) 2014 Dave Butler. All rights reserved.
//

import Foundation
import WatchKit
import SpriteKit

class ScaleUtil: NSObject {

    static let kObstacleHeight: CGFloat = 15.0
    static let kBorderWidthHeight: CGFloat = 10.0
    static let kObstacleVertSpace: CGFloat = 1550.0
    static let kObstacleHorizSpace: CGFloat = 225.0
    static let kMaxWidth: CGFloat = 310.0
    static let kMinWidth: CGFloat = 35.0
    static let kSpeedBoost: CGFloat = 0.25
    static let kSpeed: CGFloat = 13.75
    
    
    class func positionGameScene() -> CGPoint {
        return CGPoint(x: CGFloat(44.0), y: CGFloat(-42.0))
    }

    class func getSceneBoundry() -> CGRect {
        return CGRect(x: 0.0, y: CGFloat(-48), width: 695.0, height: 1050.0)
    }

    class func getSceneSize() -> CGSize {
        return CGSize(width: 695.0, height: 1050.0)
    }

    class func getSceneCenterPoint(_ rect: CGRect) -> CGPoint {
        return CGPoint(x: CGFloat((rect.size.width / 2)), y: CGFloat((rect.size.height / 2) - 40))
        //will move background
    }

    class func getGameSceneCenterPoint(_ rect: CGRect) -> CGPoint {
        return CGPoint(x: CGFloat((rect.size.width / 2)), y: CGFloat((rect.size.height / 2) - 40))
        //will move background
    }

    class func convert(_ point: CGPoint) -> CGPoint {
        return point
    }
    

}
