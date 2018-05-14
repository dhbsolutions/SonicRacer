//
//
//  Meteor.swift
//  SonicRacer
//
//  Created by Butler, David {BIS} on 6/27/14.
//  Copyright (c) 2014 DHBWorlds. All rights reserved.
//
//
//  Meteor.swift
//  SonicRacer
//
//  Created by Butler, David {BIS} on 7/25/14.
//  Copyright (c) 2014 DHBWorlds. All rights reserved.
//

import SpriteKit

//let ARC4RANDOM_MAX: CGFloat = 0x100000000

class Meteor: SKSpriteNode {
    var meteor: SKEmitterNode?
    var xSpeed: CGFloat = 0.0
    var isHasPlayedWhoosh: Bool = false

    var whooshSoundAction: SKAction?

    func playSound() {
        isHasPlayedWhoosh = true
        run(whooshSoundAction!)
    }

    init(spriteTextureAtlas textureAtlas: SKTextureAtlas) {

        let texture: SKTexture = textureAtlas.textureNamed("clear")
        let size: CGSize = CGSize(width: 50, height: 55)
        super.init(texture: texture, color: UIColor.clear, size: size)

        // Get random value between 1 and 5 to determine what type of ship we get
        //self.xSpeed = (arc4random_uniform(5)() % 5) + 1;
        
        let val = (CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * 18) - 9
        self.xSpeed = val;
        
        meteor = getEmitter()
        
        meteor?.position = CGPoint(x: 0.0, y: 0.0)
        physicsBody = SKPhysicsBody(circleOfRadius: 18.0)
        physicsBody?.density = 1.5
        physicsBody?.allowsRotation = false
        physicsBody?.mass = 0.05
        physicsBody?.linearDamping = 1.0
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = CollisionType.meteor.rawValue
        //self.physicsBody.contactTestBitMask = 0;
        physicsBody?.collisionBitMask = CollisionType.player.rawValue
        physicsBody?.usesPreciseCollisionDetection = true
        //the y-position needs to be slightly behind the spaceship
        //scaling the particlesystem
        meteor?.xScale = 1.0
        meteor?.yScale = 1.0
        meteor?.particleRotation = CGFloat(Int(90 * (.pi / 180.0)))
        meteor?.zPosition = 44
        meteor?.particleZPosition = 55
        addChild(meteor!)
        isHasPlayedWhoosh = false
        whooshSoundAction = SKAction.playSoundFileNamed("010796231-fireball-whoosh.m4a", waitForCompletion: true)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func removeFromParent() {
        super.removeFromParent()
    }

    func getEmitter() -> SKEmitterNode {
        let firePath: String? = Bundle.main.path(forResource: "Meteor", ofType: "sks")
        let fire: SKEmitterNode? = NSKeyedUnarchiver.unarchiveObject(withFile: firePath!) as? SKEmitterNode
        //SKEffectNode *fireEffect = [[SKEffectNode alloc] init];
        //[fireEffect addChild: fire];
        return fire!
    }
}

