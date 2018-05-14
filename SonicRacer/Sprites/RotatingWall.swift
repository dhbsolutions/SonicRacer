//
//
//  RotatingWall.swift
//  SonicRacer
//
//  Created by Butler, David {BIS} on 7/25/14.
//  Copyright (c) 2014 DHBWorlds. All rights reserved.
//

import SpriteKit

class RotatingWall: SKSpriteNode {
    enum SpinDirection: Int {
        case directionLeft = 1
        case directionRight = 2
    }


    var rockettrail: SKEmitterNode?
    var spinDirection: Int = 1

    var whooshSoundAction: SKAction?
    var repeatWhooshSoundAction: SKAction?

    //@property (nonatomic) BOOL hasPlayedWhoosh;
    func playSound() {
        //self.hasPlayedWhoosh=YES;
        run(repeatWhooshSoundAction!, withKey: "whoosh")
    }

    init(spriteTextureAtlas textureAtlas: SKTextureAtlas) {

        // Get random value between 1 and 5 to determine what type of ship we get
        
        let spinDirection: SpinDirection = SpinDirection(rawValue: Int(UInt32((arc4random() % 2) + 1)))!

        
        let size: CGSize = CGSize(width: 250.0, height: CGFloat(53))
        let texture: SKTexture = textureAtlas.textureNamed("SpinningWall")
        
        super.init(texture: texture, color: UIColor.clear, size: size)

        rockettrail = getFireEmitter()
        physicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width: 250.0, height: 50.0))
        physicsBody?.density = 1.5
        physicsBody?.allowsRotation = true
        physicsBody?.mass = 0.05
        physicsBody?.linearDamping = 1.0
        physicsBody?.isDynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = CollisionType.rotatingWall.rawValue
        physicsBody?.contactTestBitMask = 0
        physicsBody?.collisionBitMask = CollisionType.player.rawValue
        physicsBody?.usesPreciseCollisionDetection = true
        //the y-position needs to be slightly behind the spaceship
        //scaling the particlesystem
        rockettrail?.xScale = 1.0
        rockettrail?.yScale = 1.0
        var rightOrLeft: Int = 1
        
        
        if spinDirection == .directionLeft {
            rightOrLeft = -1
        }
        rockettrail?.position = CGPoint(x: CGFloat(95 * rightOrLeft * -1), y: CGFloat((size.height / 2) + 5))
        let action: SKAction = SKAction.rotate(byAngle: CGFloat(Float(rightOrLeft) * Float.pi), duration: 3.1)
        run(SKAction.repeatForever(action))
        //changing the targetnode from spaceship to scene so that it gets influenced by movement
        addChild(rockettrail!)
        //self.hasPlayedWhoosh=NO;
        whooshSoundAction = SKAction.playSoundFileNamed("039144361-top-deep-medium-whoosh-swoosh-.m4a", waitForCompletion: true)
        repeatWhooshSoundAction = SKAction.repeatForever(whooshSoundAction!)
        playSound()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func removeFromParent() {
        super.removeFromParent()
    }

    func getFireEmitter() -> SKEmitterNode {
        let firePath: String? = Bundle.main.path(forResource: "AlienFire", ofType: "sks")
        let fire: SKEmitterNode? = NSKeyedUnarchiver.unarchiveObject(withFile: firePath!) as? SKEmitterNode
        return fire!
    }
}
