//
//
//  AlienShip.swift
//  SonicRacer
//
//  Created by Butler, David {BIS} on 6/27/14.
//  Copyright (c) 2014 DHBWorlds. All rights reserved.
//

import SpriteKit

class AlienShip: SKSpriteNode {
    enum AlienShipType : Int {
        case greenShip = 1
        case triShip = 2
        case redEgg = 3
        case purpleShip = 4
        case redDual = 5
    }


    var rockettrail: SKEmitterNode?
    var isHasPlayedWhoosh: Bool = false

    var whooshSoundAction: SKAction?

    init(spriteTextureAtlas textureAtlas: SKTextureAtlas) {

        // Get random value between 1 and 5 to determine what type of ship we get
        let alienShipType: AlienShipType = AlienShip.AlienShipType(rawValue: Int(UInt32((arc4random() % 5) + 1)))!
        var texture: SKTexture!
        var size: CGSize!
        
        if alienShipType == .greenShip {
            size = CGSize(width: 50.0, height: 55.0)
            texture = textureAtlas.textureNamed("GreeenShip_50X55")
        }
        else if alienShipType == .triShip {
            size = CGSize(width: 45.0, height: 43.0)
            texture = textureAtlas.textureNamed("TriShip_45X43")
        }
        else if alienShipType == .redEgg {
            size = CGSize(width: 30.0, height: 20.0)
            texture = textureAtlas.textureNamed("RedEgg_30X20")
        }

        if alienShipType == .purpleShip {
            size = CGSize(width: 90.0, height: 90.0)
            texture = textureAtlas.textureNamed("PurpleShip_90X90")
        }
        if alienShipType == .redDual {
            size = CGSize(width: 70.0, height: 71.0)
            texture = textureAtlas.textureNamed("RedDual_70X71")
        }
        
        super.init(texture: texture, color: UIColor.clear, size: size)
        self.rockettrail = getFireEmitter()

        self.rockettrail?.position = CGPoint(x: 0.0, y: CGFloat((size.height / 2) + 10))
        self.rockettrail?.particleRotation = CGFloat(90.00 * (.pi / 180.0))
        self.rockettrail?.zPosition = 80
        zPosition = 120
        physicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width: CGFloat(size.width - 8), height: CGFloat((size.height / 2) - 8)))
        physicsBody?.density = 1.5
        physicsBody?.allowsRotation = true
        physicsBody?.mass = 0.05
        physicsBody?.linearDamping = 1.0
        physicsBody?.isDynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = CollisionType.enemyShip.rawValue
        physicsBody?.contactTestBitMask = 0
        physicsBody?.collisionBitMask = CollisionType.player.rawValue
        physicsBody?.usesPreciseCollisionDetection = true
        //the y-position needs to be slightly behind the spaceship
        //scaling the particlesystem
        rockettrail?.xScale = 1.4
        rockettrail?.yScale = 1.0
        //changing the targetnode from spaceship to scene so that it gets influenced by movement
        addChild(rockettrail!)
        isHasPlayedWhoosh = false
        whooshSoundAction = SKAction.playSoundFileNamed("006226379-rocket-whoosh-33.m4a", waitForCompletion: true)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func playSound() {
        isHasPlayedWhoosh = true
        run(whooshSoundAction!)
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
