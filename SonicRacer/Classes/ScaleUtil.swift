//
//
//  ScaleUtil.swift
//  TiltMaze
//
//  Created by Butler, David {BIS} on 3/12/14.
//  Copyright (c) 2014 Dave Butler. All rights reserved.
//

import Foundation
import UIKit

let IS_WIDESCREEN = (fabs(Double(UIScreen.main.bounds.size.height) - Double(568)) < DBL_EPSILON)

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
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return CGPoint(x: CGFloat(80.0), y: CGFloat(-48.0))
        }
        else {
            if IS_WIDESCREEN {
                return CGPoint(x: CGFloat(16.0), y: CGFloat(-48.0))
            }
            else {
                return CGPoint(x: CGFloat(44.0), y: CGFloat(-42.0))
            }
        }
    }


    class func getSceneBoundry() -> CGRect {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return CGRect(x: CGFloat(48), y: CGFloat(-32), width: CGFloat(768), height: 1024.0)
        }
        else {
            if IS_WIDESCREEN {
                return CGRect(x: 0.0, y: CGFloat(32), width: 640.0, height: CGFloat(1136))
            }
            else {
                //return CGRectMake(0, -16, 640, 960);
                return CGRect(x: 0.0, y: CGFloat(-48), width: 695.0, height: 1050.0)
            }
        }
    }

    class func getSceneSize() -> CGSize {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return CGSize(width: CGFloat(768), height: 1024.0)
        }
        else {
            if IS_WIDESCREEN {
                return CGSize(width: 640.0, height: CGFloat(1136))
            }
            else {
                //return CGRectMake(0, -16, 640, 960);
                return CGSize(width: 695.0, height: 1050.0)
            }
        }
    }

    class func getSceneCenterPoint(_ rect: CGRect) -> CGPoint {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return CGPoint(x: CGFloat((rect.size.width / 2)), y: CGFloat((rect.size.height / 2) - 32))
        }
        else {
            if IS_WIDESCREEN {
                //DHB CHANGED THIS LINE******
                return CGPoint(x: CGFloat((rect.size.width / 2)), y: CGFloat((rect.size.height / 2) - 120))
            }
            else {
                //DHB CHANGED THIS LINE******
                return CGPoint(x: CGFloat((rect.size.width / 2)), y: CGFloat((rect.size.height / 2) - 40))
                //will move background
            }
        }
    }

    class func getGameSceneCenterPoint(_ rect: CGRect) -> CGPoint {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return CGPoint(x: CGFloat((rect.size.width / 2)), y: CGFloat((rect.size.height / 2) - 64))
        }
        else {
            if IS_WIDESCREEN {
                //DHB CHANGED THIS LINE******
                return CGPoint(x: CGFloat((rect.size.width / 2)), y: CGFloat((rect.size.height / 2) - 120))
            }
            else {
                //DHB CHANGED THIS LINE******
                return CGPoint(x: CGFloat((rect.size.width / 2)), y: CGFloat((rect.size.height / 2) - 40))
                //will move background
            }
        }
    }

    class func convert(_ point: CGPoint) -> CGPoint {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return CGPoint(x: CGFloat(32 + point.x * 2), y: CGFloat(64 + point.y * 2))
        }
        else {
            return point
        }
    }
}
