//
//  CommonScene.swift
//  SonicRacer
//
//  Created by David Butler on 6/25/17.
//  Copyright © 2017 DHBWorlds. All rights reserved.
//

import Foundation
import SpriteKit

class CommonScene: NSObject {

    class func newExplosion() -> SKEmitterNode {
        //instantiate explosion emitter
        let explosion = SKEmitterNode()
        //TODO: set the right properties for your particle system!
        explosion.particleTexture = SKTexture(imageNamed: "spark.png")
        explosion.particleColor = UIColor.brown
        explosion.numParticlesToEmit = 100
        explosion.particleBirthRate = 450
        explosion.particleLifetime = 2
        explosion.emissionAngleRange = 360
        explosion.particleSpeed = 100
        explosion.particleSpeedRange = 50
        explosion.xAcceleration = 0
        explosion.yAcceleration = 0
        explosion.particleAlpha = 0.8
        explosion.particleAlphaRange = 0.2
        explosion.particleAlphaSpeed = -0.5
        explosion.particleScale = 0.75
        explosion.particleScaleRange = 0.4
        explosion.particleScaleSpeed = -0.5
        explosion.particleRotation = 0
        explosion.particleRotationRange = 0
        explosion.particleRotationSpeed = 0
        explosion.particleColorBlendFactor = 1
        explosion.particleColorBlendFactorRange = 0
        explosion.particleColorBlendFactorSpeed = 0
        explosion.particleBlendMode = .add
        //add this node to parent node
        return explosion
    }

    // MARK: Emitters / Effects
    class func getBackgroundEmitter() -> SKEmitterNode! {
        let backgroundPath: String? = Bundle.main.path(forResource: "MyMagicParticle", ofType: "sks")
        let background: SKEmitterNode? = NSKeyedUnarchiver.unarchiveObject(withFile: backgroundPath!) as? SKEmitterNode
        return background!
    }

    class func isCrash(_ contact: SKPhysicsContact) -> Bool!
    {
        // 1
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        // 2
        var isCrash: Bool?
        switch contactMask {
        case CollisionType.player.rawValue | CollisionType.pointyWall.rawValue:
            isCrash=true
        case CollisionType.player.rawValue | CollisionType.enemyShip.rawValue:
            isCrash=true
        case CollisionType.player.rawValue | CollisionType.meteor.rawValue:
            isCrash=true
        case CollisionType.player.rawValue | CollisionType.rotatingWall.rawValue:
            isCrash=true
        default:
            isCrash=false
        }
        return isCrash!
    }
    
    class func randomValueBetween(low: Float, andValue high: Float) -> Float {
        return (Float(arc4random()) / 0xffffffff) * (high - low) + low
    }

}
