//
//
//  Wall.swift
//  SonicRacer
//
//  Created by Butler, David {BIS} on 6/25/14.
//  Copyright (c) 2014 DHBWorlds. All rights reserved.
//

import SpriteKit

class Wall: SKSpriteNode {
    init(spriteTexture texture: SKTexture, with size: CGSize) {

        super.init(texture: texture, color: UIColor.clear, size: size)

        physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody?.categoryBitMask = CollisionType.pointyWall.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.affectedByGravity = false
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
