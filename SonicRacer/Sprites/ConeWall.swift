//
//
//  ConeWall.swift
//  SonicRacer
//
//  Created by Butler, David {BIS} on 6/21/14.
//  Copyright (c) 2014 DHBWorlds. All rights reserved.
//

import SpriteKit

class ConeWall: SKSpriteNode {


    var coneOrientation: ConeOrientation = ConeOrientation.ConeOrientationLeft

    var coneWall: SKSpriteNode?

    init(spriteTexture texture: SKTexture, with coneOrientation: ConeOrientation) {
        
        let size: CGSize! = CGSize(width: 600.0, height: 200.0)
        
        super.init(texture: texture, color: UIColor.clear, size: size)
        
        if coneOrientation == ConeOrientation.ConeOrientationRight {
            anchorPoint = CGPoint(x: 0.0, y: 0.0)
            physicsBody = SKPhysicsBody.init(edgeFrom: CGPoint(x: 600, y: 0), to: CGPoint(x: 10, y: 188.0))
        }
        else {
            anchorPoint = CGPoint(x: 1.0, y: 0.0)
            physicsBody = SKPhysicsBody.init(edgeFrom: CGPoint(x: -600, y: 0), to: CGPoint(x: -10, y: 188.0))
        }
        physicsBody?.collisionBitMask = 0
        physicsBody?.categoryBitMask = CollisionType.pointyWall.rawValue
    
    }
    
    required convenience init(coder aCoder: NSCoder) {
        self.init(coder: aCoder)
    }
}
