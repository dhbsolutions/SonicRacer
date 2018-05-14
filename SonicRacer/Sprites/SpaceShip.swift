//
//
//  SonicRacer.h
//  SonicRacer
//
//  Created by Dave Butler on 6/10/14.
//  Copyright (c) 2014 Dave Butler. All rights reserved.
//
//
//  SonicRacer.m
//  SonicRacer
//
//  Created by Dave Butler on 6/10/14.
//  Copyright (c) 2014 Dave Butler. All rights reserved.
//

import SpriteKit

class SpaceShip: SKSpriteNode {


    var rockettrail: SKEmitterNode?
    var scrapeParticle: SKEmitterNode?
    var isScraping: Bool = false

    var fire: SKEmitterNode?
    var scrapeSoundAction: SKAction?
    var repeatScrapeSoundAction: SKAction?

    init(spriteTexture texture: SKTexture) {
        
        let size: CGSize! = CGSize(width: 90.0, height: 90.0)
        
        super.init(texture: texture, color: UIColor.clear, size: size)
        
        physicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width: CGFloat(size.width - 18), height: CGFloat(size.height - 30)))
        physicsBody?.isDynamic = true
        physicsBody?.density = 1.5
        physicsBody?.allowsRotation = true
        physicsBody?.mass = 0.05
        physicsBody?.linearDamping = 1.0
        physicsBody?.categoryBitMask = CollisionType.player.rawValue
        physicsBody?.contactTestBitMask = CollisionType.wall.rawValue | CollisionType.pointyWall.rawValue | CollisionType.meteor.rawValue | CollisionType.rotatingWall.rawValue | CollisionType.enemyShip.rawValue | CollisionType.laser.rawValue | CollisionType.spaceMine.rawValue | CollisionType.missle.rawValue | CollisionType.cannon.rawValue
        physicsBody?.collisionBitMask = CollisionType.wall.rawValue
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.affectedByGravity = false
        //self.physicsWorld.gravity = CGVectorMake(0, -2.1f);  // Low Gravity  9.8=Earth
        rockettrail = getFireEmitter()
        scrapeParticle = getScrapeEmitter()
        scrapeParticle?.xScale = 1.0
        scrapeParticle?.yScale = 1.0
        //the y-position needs to be slightly behind the spaceship
        rockettrail?.position = CGPoint(x: 0.0, y: CGFloat(-50))
        //scaling the particlesystem
        //self.rockettrail.xScale = 1.0;
        //self.rockettrail.yScale = 1.0;
        //changing the targetnode from spaceship to scene so that it gets influenced by movement
        addChild(rockettrail!)
        //self.rockettrail.targetNode=self;
        scrapeSoundAction = SKAction.playSoundFileNamed("MetalScrape.m4a", waitForCompletion: true)
        repeatScrapeSoundAction = SKAction.repeatForever(scrapeSoundAction!)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func stopScrape() {
        if isScraping == true {
            //NSLog(@"STOP");
            isScraping = false
            removeAction(forKey: "scrape")
            scrapeParticle?.removeFromParent()
            // removeChildrenInArray: [[NSArray alloc] initWithObjects: self.scrapeParticle, nil]];
        }
    }

    func scrape(scrapeDirection: ScrapeDirection) {
        if !isScraping {
            run(repeatScrapeSoundAction!, withKey: "scrape")
            //NSLog(@"start");
            if (scrapeDirection == .scrapeRight) {
                scrapeParticle?.position = CGPoint(x: CGFloat(40), y: -70.0)
            }
            else {
                scrapeParticle?.position = CGPoint(x: CGFloat(-40), y: -70.0)
            }
            scrapeParticle?.removeFromParent()
            // removeChildrenInArray: [[NSArray alloc] initWithObjects: self.scrapeParticle, nil]];
            addChild(scrapeParticle!)
            isScraping = true
        }
    }

    override func removeFromParent() {
        super.removeFromParent()
    }

    func getScrapeEmitter() -> SKEmitterNode {
        let sparkPath: String? = Bundle.main.path(forResource: "MySparkParticle", ofType: "sks")
        let spark: SKEmitterNode? = NSKeyedUnarchiver.unarchiveObject(withFile: sparkPath!) as? SKEmitterNode
        return spark!
    }

    func getFireEmitter() -> SKEmitterNode {
        let firePath: String? = Bundle.main.path(forResource: "Fire", ofType: "sks")
            /*NSData *data = [NSData dataWithContentsOfFile: firePath];
                
                NSKeyedUnarchiver* archiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
                
                [archiver setClass: [SKEmitterNode class] forClassName: @"SKEmitterNode"];
                NSError * _Nullable __autoreleasing * _Nullable err = NULL;
                SKEmitterNode *fire = (SKEmitterNode*) [archiver decodeTopLevelObjectAndReturnError: err];
                 */
            /*
                let path = NSBundle.mainBundle().pathForResource(name, ofType: "sks")
                
                var sceneData = NSData.dataWithContentsOfFile(path!, options: .DataReadingMappedIfSafe, error: nil)
                var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
                
                archiver.setClass(SKEmitterNode.self, forClassName: "SKEditorScene")
                let node = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as SKEmitterNode?
                archiver.finishDecoding()
                
                */
        let fire: SKEmitterNode? = (NSKeyedUnarchiver.unarchiveObject(withFile: firePath!) as? SKEmitterNode)
        fire?.xScale = 1.0
        fire?.yScale = 1.0
        return fire!
    }
}
