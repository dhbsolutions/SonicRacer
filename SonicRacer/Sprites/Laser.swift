//
//
//  Laser.swift
//  TiltMaze
//
//  Created by Butler, David {BIS} on 3/15/14.
//  Copyright (c) 2014 Dave Butler. All rights reserved.
//

import SpriteKit

class Laser: SKSpriteNode {
    enum LaserType : Int {
        case onOff = 1
        case moving = 2
        case buttonOnOff = 3
    }

    enum LaserOrientation : Int {
        case vertical = 1
        case horizontal = 2
    }

    enum LaserColor : Int {
        case blue = 1
        case green = 2
        case red = 3
        case purple = 4
        case orange = 5
    }


    var isOn: Bool = false
    var initialPosition = CGPoint.zero
    var isMovingForward: Bool = false
    var laserOrientation = LaserOrientation(rawValue: 0)!
    var laserType = LaserType(rawValue: 0)!
    var laserColor = LaserColor(rawValue: 0)!

    var laser: SKSpriteNode?

   /* init(spriteLaserType laserType: LaserType, with laserOrientation: LaserOrientation, with laserColor: LaserColor) {
        super.init()

        self.laserType = laserType
        self.laserOrientation = laserOrientation
        self.laserColor = laserColor
        isOn = true
        if laserOrientation == .vertical {
            physicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width: CGFloat(6), height: CGFloat(32)))
            switch laserColor {
                case .red:
                    laser = SKSpriteNode(imageNamed: "LaserRedV")
                case .blue:
                    laser = SKSpriteNode(imageNamed: "LaserBlueV")
                case .purple:
                    laser = SKSpriteNode(imageNamed: "LaserPurpleV")
                case .green:
                    laser = SKSpriteNode(imageNamed: "LaserGreenV")
                case .orange:
                    laser = SKSpriteNode(imageNamed: "LaserOrangeV")
            }
        }
        else {
            physicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width: CGFloat(32), height: CGFloat(6)))
            switch laserColor {
                case .red:
                    laser = SKSpriteNode(imageNamed: "LaserRedH")
                case .blue:
                    laser = SKSpriteNode(imageNamed: "LaserBlueH")
                case .purple:
                    laser = SKSpriteNode(imageNamed: "LaserPurpleH")
                case .green:
                    laser = SKSpriteNode(imageNamed: "LaserGreenH")
                case .orange:
                    laser = SKSpriteNode(imageNamed: "LaserOrangeH")
            }
        }
        laser?.size = CGSize(width: CGFloat(32), height: CGFloat(32))
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = CollisionType.laser.rawValue
        physicsBody?.collisionBitMask = 0
        if laserType == .onOff {
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
            let wait1Action = SKAction.wait(forDuration: 2)
            let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
            let wait2Action = SKAction.wait(forDuration: 1.5)
                //SKAction *soundAction = [SKAction playSoundFileNamed:@"Laser.m4a" waitForCompletion:NO];
            let laserAnimAction = SKAction.sequence([SKAction.run({() -> Void in
                    //[self.laserMusicPlayer play];
                    self.isOn = true
                }),                     //soundAction,
fadeInAction, wait2Action, SKAction.run({() -> Void in
                    //[self.laserMusicPlayer pause];
                    self.isOn = false
                }), fadeOutAction, wait1Action])
            laser?.run(SKAction.repeatForever(laserAnimAction))
        }
        addChild(laser!)
    
    }*/
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update() {
        if laserType == .moving {
            if laserOrientation == .vertical {
                if position.y >= initialPosition.y + 32 {
                    isMovingForward = false
                }
                if position.y <= initialPosition.y - 32 {
                    isMovingForward = true
                }
                if isMovingForward {
                    physicsBody?.velocity = CGVector.init(dx: 0.0, dy: 50.0)
                }
                else {
                    physicsBody?.velocity = CGVector.init(dx: 0.0, dy: -50.0)
                }
            }
            else {
                if position.x >= initialPosition.x + 32 {
                    isMovingForward = false
                }
                if position.x <= initialPosition.x - 32 {
                    isMovingForward = true
                }
                if isMovingForward {
                    physicsBody?.velocity = CGVector.init(dx: 50.0, dy: 0.0)
                }
                else {
                    physicsBody?.velocity = CGVector.init(dx: -50.0, dy: 0.0)
                }
            }
        }
    }

    func turnOff() {
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        laser?.run(fadeOutAction)
        isOn = false
    }

    /*
    -(void) laserBumped
    {
        
        if(self.isOn)
        {
        
        
        }
          NSMutableArray *images=[NSMutableArray arrayWithCapacity:1];
        
          NSString *fileName=@"PinballBumperOn.png";
          SKTexture *tempTexture=[SKTexture textureWithImageNamed:fileName];
          [images addObject:tempTexture];
          //self.laser.hidden;
          //NSUInteger numberOfFrames = [images count];
    
          [SKTexture preloadTextures:images withCompletionHandler:^(void)
          {
            //SKAction *bumperImageAction = [SKAction animateWithTextures:images timePerFrame:1.0f/numberOfFrames];
            SKAction *bumperImageAction = [SKAction animateWithTextures: images timePerFrame:0.2 resize:NO restore:YES];
    
            SKAction *soundAction = [SKAction playSoundFileNamed:@"PinballBumper.m4a" waitForCompletion:NO];
    
            SKAction *bumperAnimAction = [SKAction sequence:@[[SKAction group:@[bumperImageAction, soundAction]]]];
            [self.laser runAction:bumperAnimAction];
          }];
    
    }
    */

    override func removeFromParent() {
        super.removeFromParent()
    }
}
