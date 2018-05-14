//  GameScene.swift
//  sonicRacerWatch Extension
//
//  Created by David Butler on 4/28/17.
//  Copyright © 2017 DHBWorlds. All rights reserved.
//
//
//  MyScene.m
//  SonicRacer
//
//  Created by Dave Butler on 6/10/14.
//  Copyright (c) 2014 Dave Butler. All rights reserved.
//

import CoreMotion
import SpriteKit
import WatchConnectivity
import WatchKit

//#import "AppDelegate.h"
class GameScene: SKScene, SKPhysicsContactDelegate, WCSessionDelegate {

    @IBOutlet weak var skInterfaceRef: WKInterfaceSKScene!

    var isGameStarted: Bool = false
    var spaceShip: SpaceShip?
    var obstacles = [SKSpriteNode]()
    var isGameOver: Bool = false
    var world: SKNode?
    var currentDistanceBetweenObstacles: CGFloat = 0.0
    var spaceShipY: CGFloat = 0.0
    var explosionAction: SKAction?
    //@property (nonatomic, weak) UITouch             *touch;
    var targetPosition = CGPoint.zero
    var scoreLabel: SKLabelNode?
    var highLabel: SKLabelNode?
    var score: Int = 0
    var lastScore: Int = 0
    var stage: Int = 0
    var imageAtlas: SKTextureAtlas?
    var isMovingFasterDisplay: Bool = false
    var fasterAction: SKAction?
    var isShouldUpdateScore: Bool = false
    var movingMetalSoundAction: SKAction?
    //LevelUp
    var fasterLabel: SKLabelNode?
    var stageLabel: SKLabelNode?
    //Main Menu
    var titleLabel: SKLabelNode?
    var swipeToMoveLabel: SKLabelNode?
    var tapToPlayLabel: SKLabelNode?
    //@property (nonatomic) SpriteButton              *leaderBoardButton;
    //@property (nonatomic) SpriteButton              *moreStuffButton;
    //@property (nonatomic) SpriteButton              *rateItButton;
    var titleFlashAction: SKAction?
    var titleFlashRepeatAction: SKAction?
    var lastScoreLabel: SKLabelNode?
    //@property (nonatomic) SpriteButton              *shareButton;
    //Credit Screen
    /*@property (nonatomic) SKSpriteNode               *creditBackground;
    @property (nonatomic) SKSpriteNode              *creditsImage;
    @property (nonatomic) SpriteButton              *exitCreditButton;
    @property (nonatomic) SpriteButton              *ltmButton;
    @property (nonatomic) SpriteButton              *ltmButton2;
    @property (nonatomic) SKLabelNode               *ltmLabel;
    @property (nonatomic) SKLabelNode               *otherGamesLabel;
    @property (nonatomic) BOOL                      isCreditScreenOn;*/
    var lastX: CGFloat = 0.0

    func moveImage(forTouches location: CGPoint) {
        //CGFloat x1 = (self.spaceShip.frame.origin.x);
        //CGFloat x2 = (location.x);
        //    if(self.isCreditScreenOn) {return;}
        if !isGameStarted {
            removeMainMenu()
            isGameStarted = true
            spaceShip?.physicsBody?.isDynamic = true
        }
        if (scene?.frame.contains(location))! {
            if !isGameStarted {
                removeMainMenu()
                isGameStarted = true
                spaceShip?.physicsBody?.isDynamic = true
            }
            var x: CGFloat = (location.x * 5) - 10.0
            if x > 620 {
                x = 620
            }
            //NSLog(@"x=%f     location.x=%f", x, location.x);
            lastX = x
            spaceShip?.run(SKAction.move(to: CGPoint(x: x, y: CGFloat(spaceShipY)), duration: 0.02))
        }
    }

    func moveImage(forCrown rotationalDelta: Double) {
            //CGFloat x1 = (self.spaceShip.position.x);
        let deltaX: CGFloat = (CGFloat(rotationalDelta * 460 * 5))
        var x2: CGFloat = (lastX) + deltaX
        //    if(self.isCreditScreenOn) {return;}
        if !isGameStarted {
            removeMainMenu()
            isGameStarted = true
            spaceShip?.physicsBody?.isDynamic = true
        }
        //if(CGRectContainsPoint(self.scene.frame, location))
        do {
            if !isGameStarted {
                removeMainMenu()
                isGameStarted = true
                spaceShip?.physicsBody?.isDynamic = true
            }
            if (x2) < -10 {
                x2 = -10.0
            }
            if x2 > 620.0 {
                x2 = 620.0
            }
            // NSLog(@"OLD X=%f     NEW X=%f,            DELTA X=%f", self.spaceShip.position.x, x2, deltaX);
            lastX = x2
            spaceShip?.run(SKAction.move(to: CGPoint(x: x2, y: CGFloat(spaceShipY)), duration: 0.2))
        }
    }

    override func sceneDidLoad() {
        lastScore = 0
        if WCSession.isSupported() {
            let session = WCSession.default
            session().delegate = self
            session().activate()
        }
        load()
    }

    //WC Session Delegate Method
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }

    func load() {
        if spaceShip != nil {
            spaceShip?.removeFromParent()
        }
        if world != nil {
            world?.removeAllActions()
            world?.removeAllChildren()
        }
        // Setup your scene here
        if imageAtlas == nil {
            // Load the atlas that contains the sprites
            self.imageAtlas = SKTextureAtlas.init(named: "images")
        }
        //self.isCreditScreenOn=NO;
        score = 0
        spaceShipY = 330
        stage = 0
        isShouldUpdateScore = false
        isGameStarted = false
        isGameOver = false
        currentDistanceBetweenObstacles = 0
        //Set Background Center Pt
        //self.background.position = [ScaleUtil getGameSceneCenterPoint: self.frame];
        // Add a node for the world - this is where sprites and tiles are added
        self.world = SKNode.init()
        self.world?.position = ScaleUtil.positionGameScene()
        backgroundColor = SKColor.black
        physicsBody = SKPhysicsBody.init(edgeLoopFrom: CGRect(x: CGFloat(frame.origin.x), y: CGFloat(frame.origin.y - 220), width: CGFloat(frame.size.width), height: CGFloat(frame.size.height + 1300)))
        spaceShip = SpaceShip(spriteTexture: (imageAtlas?.textureNamed("Fighter_90X90"))!)
        spaceShip?.position = CGPoint(x: CGFloat((size.width / 2) - 40), y: CGFloat(spaceShipY))
        lastX = ((size.width / 2.0) - 40.0)
        world?.addChild(spaceShip!)
            /////  **************     960*640 = Playable AREA   *********
        let wallLeft = SKSpriteNode(texture: imageAtlas?.textureNamed("WallLeft"))
        wallLeft.size = CGSize(width: 100.0, height: 2400.0)
        let leftWallBasePoint = CGPoint(x: CGFloat(-85), y: 0.0)
        wallLeft.position = leftWallBasePoint
        wallLeft.physicsBody = SKPhysicsBody.init(rectangleOf: wallLeft.size)
        wallLeft.zPosition = 400
        //Bring to Front
        wallLeft.physicsBody?.isDynamic = false
        wallLeft.physicsBody?.affectedByGravity = false
        wallLeft.physicsBody?.categoryBitMask = CollisionType.wall.rawValue
        wallLeft.physicsBody?.contactTestBitMask = 0
        wallLeft.physicsBody?.collisionBitMask = CollisionType.player.rawValue
        let wallRight = SKSpriteNode(texture: imageAtlas?.textureNamed("WallRight"))
        wallRight.size = CGSize(width: 100.0, height: 2400.0)
        let rightWallBasePoint = CGPoint(x: 695.0, y: 0.0)
        wallRight.position = rightWallBasePoint
        wallRight.physicsBody = SKPhysicsBody.init(rectangleOf: wallRight.size)
        wallRight.physicsBody?.isDynamic = false
        wallRight.zPosition = 400
        //Bring to Front
        wallRight.physicsBody?.affectedByGravity = false
        wallRight.physicsBody?.categoryBitMask = CollisionType.wall.rawValue
        wallRight.physicsBody?.contactTestBitMask = 0
        wallRight.physicsBody?.collisionBitMask = CollisionType.player.rawValue
        world?.addChild(wallLeft)
        world?.addChild(wallRight)
        movingMetalSoundAction = SKAction.playSoundFileNamed("040274362-robot-mech-servo-movement-02.m4a", waitForCompletion: true)
        self.obstacles = [SKSpriteNode]()
        addNewObstacle()
        let background: SKEmitterNode? = CommonScene.getBackgroundEmitter()
        background?.position = ScaleUtil.getGameSceneCenterPoint((scene?.frame)!)
        background?.xScale = 1.0
        background?.yScale = 1.0
        background?.zPosition = -1
        world?.addChild(background!)
        physicsWorld.contactDelegate = self
        explosionAction = SKAction.playSoundFileNamed("008745928-explosiondistant.m4a", waitForCompletion: false)
        //if(!self.scoreLabel)
        do {
            setupScoreBoard()
        }
        setupMainMenu()
        scoreLabel?.text = "0"
        let defaults = UserDefaults.standard
        var highScore: Int = defaults.integer(forKey: "HighScore")
        // Wasnt recorded before so this is a new high
        if highScore == 0 {
            highScore = 0
        }
        highLabel?.text = "\(NSLocalizedString("Best", comment: "Best high score label")):\(Int(highScore))"
        stageLabel = SKLabelNode(fontNamed: "Helvetica")
        stageLabel?.fontSize = 72
        stageLabel?.fontColor = SKColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.6)
        stageLabel?.horizontalAlignmentMode = .center
        stageLabel?.text = NSLocalizedString("STAGE", comment: "STAGE Label")
        stageLabel?.position = CGPoint(x: 900.0, y: CGFloat(size.height / 2 + 200))
        fasterLabel = SKLabelNode(fontNamed: "Helvetica")
        fasterLabel?.fontSize = 72
        fasterLabel?.fontColor = SKColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.6)
        fasterLabel?.horizontalAlignmentMode = .center
        fasterLabel?.text = NSLocalizedString("GOING FASTER", comment: "GOING FASTER Label")
        fasterLabel?.position = CGPoint(x: 900.0, y: CGFloat(size.height / 2 + 100))
        fasterAction = SKAction.sequence([SKAction.moveTo(x: (scene?.size.width)! / 2, duration: 0.5), SKAction.wait(forDuration: 1.2), SKAction.moveTo(x: -400, duration: 0.5)])
        world?.addChild(scoreLabel!)
        world?.addChild(highLabel!)
        addChild(world!)
    }

// MARK: MENUS / SCOREBOARD
    func setupScoreBoard() {
        scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel?.fontSize = 72
        scoreLabel?.fontColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
        scoreLabel?.horizontalAlignmentMode = .right
        highLabel = SKLabelNode(fontNamed: "Helvetica")
        //]@"Helvetica"];
        highLabel?.fontSize = 72
        highLabel?.fontColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
        highLabel?.horizontalAlignmentMode = .left
        highLabel?.position = CGPoint(x: 20.0, y: 850.0)
        scoreLabel?.position = CGPoint(x: 600.0, y: 850.0)
    }

    func setupMainMenu() {
        //AppDelegate *appDelegate= (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //if(!self.titleLabel)
        //do {
            titleLabel = SKLabelNode(fontNamed: "Helvetica")
            titleLabel?.fontColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            titleLabel?.horizontalAlignmentMode = .center
            titleLabel?.position = CGPoint(x: CGFloat(size.width / 2) - 40.0, y: CGFloat((size.height / 2) + 80))
            let sonicString = NSLocalizedString("Sonic Racer", comment: "Sonic Racer")
            if (sonicString.characters.count ) >= 13 {
                titleLabel?.fontSize = 72
            }
            else {
                titleLabel?.fontSize = 84
            }
            titleLabel?.text = sonicString
            tapToPlayLabel = SKLabelNode(fontNamed: "Helvetica")
            if (sonicString.characters.count) > 13 {
                tapToPlayLabel?.fontSize = 32
            }
            else {
                tapToPlayLabel?.fontSize = 48
            }
            tapToPlayLabel?.fontColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
            tapToPlayLabel?.horizontalAlignmentMode = .center
            tapToPlayLabel?.position = CGPoint(x: (size.width / 2) - 40.0, y: CGFloat(size.height / 2))
            tapToPlayLabel?.text = NSLocalizedString("TAP TO START", comment: "TAP TO START")
            swipeToMoveLabel = SKLabelNode(fontNamed: "Helvetica")
            swipeToMoveLabel?.fontSize = 32
            swipeToMoveLabel?.fontColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
            swipeToMoveLabel?.horizontalAlignmentMode = .center
            swipeToMoveLabel?.position = CGPoint(x: (size.width / 2) - 40.0, y: CGFloat((size.height / 2) - 40))
            swipeToMoveLabel?.text = "<--------- \(NSLocalizedString("swipe to move", comment: "swipe to move label")) --------->"
            lastScoreLabel = SKLabelNode(fontNamed: "Helvetica")
            lastScoreLabel?.fontSize = 72
            lastScoreLabel?.fontColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
            lastScoreLabel?.horizontalAlignmentMode = .center
            lastScoreLabel?.position = CGPoint(x: ((size.width / 2) - 40.0), y: CGFloat((size.height / 2) + 200))
            /* if(appDelegate.gamesPlayed > 2)
                    {
                        self.rateItButton = [self createSpriteButtonNamed: @"RateIt" withText: NSLocalizedString(@"RATE IT", @"RATE IT") ];
                        [self.rateItButton.title setFontName:@"Helvetica"];
                        [self.rateItButton.title setFontSize:64.0];
                        self.rateItButton.position = CGPointMake((self.size.width/2), (self.size.height/2) - 100);
                        [self.rateItButton setTouchUpInsideTarget:self action:@selector(rateItButtonPressed)];
                        [self addChild: self.rateItButton];
                    }*/
            //self.leaderBoardButton = [self createSpriteButtonNamed: @"LeaderBoard" withText: NSLocalizedString(@"LeaderBoard", @"LeaderBoard") ];
            //        self.moreStuffButton  = [self createSpriteButtonNamed: @"More" withText: NSLocalizedString(@"More", @"More")  ];
            //self.shareButton = [self createSpriteButtonNamed: @"Share" withText: NSLocalizedString(@"SHARE", @"SHARE")  ];
            //[self.leaderBoardButton setTouchUpInsideTarget:self action:@selector(leaderBoardButtonPressed)];
            //        [self.moreStuffButton setTouchUpInsideTarget:self action:@selector(moreButtonPressed)];
            //[self.shareButton setTouchUpInsideTarget:self action:@selector(shareButtonPressed)];
            //self.shareButton.position = CGPointMake((self.size.width/2), (self.size.height/2)  + 290);
            //[self.shareButton.title setFontName: @"Helvetica"];
            //[self.shareButton.title setFontSize: 48];
            //self.leaderBoardButton.title.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
            //        self.moreStuffButton.title.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
            //self.leaderBoardButton.position = CGPointMake(160, 50);
            //        self.moreStuffButton.position = CGPointMake(600, 50);
        //}
        world?.addChild(titleLabel!)
        world?.addChild(swipeToMoveLabel!)
        // [self addChild: self.leaderBoardButton];
        world?.addChild(tapToPlayLabel!)
        //    [self.world addChild: self.moreStuffButton];
        if lastScore > 0 {
            lastScoreLabel?.text = "\(NSLocalizedString("YOUR SCORE", comment: "YOUR SCORE label")): \(lastScore)"
            world?.addChild(lastScoreLabel!)
        }
       // titleLabel?.run(titleFlashRepeatAction!, withKey: "flash")
    }

    func removeMainMenu() {
        titleLabel?.removeFromParent()
        swipeToMoveLabel?.removeFromParent()
        //[self.leaderBoardButton removeFromParent];
        tapToPlayLabel?.removeFromParent()
        //    [self.moreStuffButton removeFromParent];
        //[self.shareButton removeFromParent];
        lastScoreLabel?.removeFromParent()
        //if(self.rateItButton) {[self.rateItButton removeFromParent];}
    }

    func leaderBoardButtonPressed() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "presentLeaderboards"), object: nil)
        //Sends message to viewcontroller to show more screen.
    }

    func shareButtonPressed() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "share"), object: nil)
        //Sends message to viewcontroller to share score.
    }

/*    func createSpriteButtonNamed(_ name: String, withText text: String) -> SpriteButton {
        let button = SpriteButton(texture: (imageAtlas?.textureNamed("clear"))!, color: UIColor.green, size: CGSize(width: 400.0, height: 80.0))
        button.title?.text = text
        button.title?.fontName = "Helvetica"
        button.title?.fontColor = SKColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.6)
        button.color = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.01)
        button.title?.fontSize = 32.0
        button.name = name
        button.zPosition = 9
        return button
    }
*/
    

// MARK: Obstacles
    func addNewObstacle() {
        if isShouldUpdateScore {
            DispatchQueue.main.async(execute: {() -> Void in
                self.scoreLabel?.text = "\(self.score)"
                print("SELF.SCORE=\(self.score)")
            })
            score += 1
        }
        else {
            isShouldUpdateScore = true
        }
        if score > 10 && (score - 1) % 10 == 0 && !isMovingFasterDisplay {
            stage += 1
            stageLabel?.position = CGPoint(x: 900.0, y: CGFloat(size.height / 2 + 200))
            fasterLabel?.position = CGPoint(x: 900.0, y: CGFloat(size.height / 2 + 100))
            stageLabel?.text = "\(NSLocalizedString("STAGE", comment: "STAGE label")) \(stage + 1)"
            world?.addChild(stageLabel!)
            world?.addChild(fasterLabel!)
            isMovingFasterDisplay = true
            isShouldUpdateScore = false
            stageLabel?.run(fasterAction!, completion: {(_: Void) -> Void in
                self.stageLabel?.removeFromParent()
            })
            fasterLabel?.run(fasterAction!, completion: {(_: Void) -> Void in
                self.isMovingFasterDisplay = false
                self.isShouldUpdateScore = true
                self.fasterLabel?.removeFromParent()
            })
            return
        }
            // Get random value between 1 and 2 to determine what type of obstaccle we get
        let obstacleType: ObstacleType = ObstacleType(rawValue: Int((arc4random() % 5) + 1))!
        // CRASH TEST
        if obstacleType == .pointyWallObstacle {
            addPointyWallObstacles()
        }
        else if obstacleType == .alienShipObstacle {
            addAlienShipObstacles()
        }
        else if obstacleType == .greenLightWallObstacle {
            addGreenLightWallObstacles()
        }
        else if obstacleType == .meteorObstacle {
            addMeteorObstacles()
        }
        else if obstacleType == .rotatingWallObstacle {
            addRotatingWallObstacles()
        }

    }

    func addRotatingWallObstacles() {
        //Generate 5 ships at random positions
        for i in 1...3 {
            let rotatingWall = RotatingWall(spriteTextureAtlas: imageAtlas!)
            var intersects: Bool = true
            while intersects {
                let wallPosition = CGPoint(x: CGFloat(CommonScene.randomValueBetween(low: Float(ScaleUtil.kMinWidth), andValue: Float(ScaleUtil.kMaxWidth)) * 2), y: CGFloat(950 + (i * 350)))
                rotatingWall.position = wallPosition
                //Make sure we didnt just place it ontop of anotehr ship
                if rotatingWall.physicsBody?.allContactedBodies().count == 0 {
                    intersects = false
                }
            }
            world?.addChild(rotatingWall)
            self.obstacles.append(rotatingWall)
        }
    }

    func playSlidingMetalSound() {
        run(movingMetalSoundAction!)
    }

    func addMeteorObstacles() {
        //Generate 5 ships at random positions
        for i in 1...6 {
            let meteor = Meteor(spriteTextureAtlas: imageAtlas!)
            var intersects: Bool = true
            while intersects {
                let meteorPosition = CGPoint(x: CGFloat(CommonScene.randomValueBetween(low: Float(ScaleUtil.kMinWidth - 200), andValue: Float(ScaleUtil.kMaxWidth + 200)) * 2), y: CGFloat(CommonScene.randomValueBetween(low: 1150, andValue: 1780)))
                meteor.position = meteorPosition
                //Make sure we didnt just place it ontop of anotehr ship
                if meteor.physicsBody?.allContactedBodies().count == 0 {
                    intersects = false
                }
            }
            world?.addChild(meteor)
            self.obstacles.append(meteor)
        }
    }

    func addAlienShipObstacles() {
        //Generate 5 ships at random positions
        for i in 1...4 {
            let alienShip = AlienShip(spriteTextureAtlas: imageAtlas!)
            var intersects: Bool = true
            while intersects {
                let alienShipPosition = CGPoint(x: CGFloat(CommonScene.randomValueBetween(low: Float(ScaleUtil.kMinWidth), andValue: Float(ScaleUtil.kMaxWidth)) * 2), y: CGFloat(CommonScene.randomValueBetween(low: 1150, andValue: 1780)))
                alienShip.position = alienShipPosition
                //Make sure we didnt just place it ontop of anotehr ship
                if alienShip.physicsBody?.allContactedBodies().count == 0 {
                    intersects = false
                }
            }
            world?.addChild(alienShip)
            self.obstacles.append(alienShip)
        }
    }

    func addPointyWallObstacles() {
        let obstacleRight = ConeWall(spriteTexture: (imageAtlas?.textureNamed("RightPointyWall"))!, with: ConeOrientation.ConeOrientationRight)
            //spriteNodeWithTexture: [self.imageAtlas textureNamed: @"RightPointyWall"]];
        let rightObstacleBasePoint = CGPoint(x: CGFloat(ScaleUtil.kMaxWidth * 2), y: 1400.0)
        let rightObstacleEndPoint = CGPoint(x: CGFloat(CommonScene.randomValueBetween(low: Float(ScaleUtil.kMinWidth), andValue: Float(ScaleUtil.kMaxWidth)) * 2), y: 1400.0)
        obstacleRight.position = rightObstacleBasePoint
        let obstacleLeft = ConeWall(spriteTexture: (imageAtlas?.textureNamed("LeftPointyWall"))!, with: ConeOrientation.ConeOrientationLeft)
        obstacleLeft.position = CGPoint(x: 0.0, y: CGFloat(obstacleRight.position.y))
            //CGPointMake(0,0);
        let obstacleLeftEndPoint = CGPoint(x: CGFloat(rightObstacleEndPoint.x - ScaleUtil.kObstacleHorizSpace), y: CGFloat(obstacleRight.position.y))
        world?.addChild(obstacleRight)
        world?.addChild(obstacleLeft)
        self.obstacles.append(obstacleRight)
        self.obstacles.append(obstacleLeft)
        obstacleRight.run(SKAction.moveTo(x: rightObstacleEndPoint.x, duration: 1.0))
        obstacleLeft.run(SKAction.moveTo(x: obstacleLeftEndPoint.x, duration: 1.0))
        playSlidingMetalSound()
    }

    func addGreenLightWallObstacles() {
        var xOffset: CGFloat
        xOffset = -55.0
        let obstacleCenter = Wall(spriteTexture: (imageAtlas?.textureNamed("SolidWall"))!, with: CGSize(width: CGFloat(CommonScene.randomValueBetween(low: 100, andValue: 450)), height: 60.0))
        obstacleCenter.position = CGPoint(x: CGFloat((scene?.size.width)! / 2.0) + CGFloat(xOffset), y: 1400.0)
        let greenLight = SKSpriteNode(texture: imageAtlas?.textureNamed("GreenLight109X109"))
        // leave room for 150 space
        greenLight.size = CGSize(width: CGFloat(40), height: CGFloat(40))
        greenLight.zPosition = 12
            // Get random value between 0 and 1 to determine what type of obstaccle we get 0 = Left 1 = Right
        var rightOrLeft: Int = Int(arc4random() % 2)
        if rightOrLeft == 0 {
            rightOrLeft = -1
        }
        let center: CGFloat = CGFloat((scene?.size.width)! / 2)
        let tmp: CGFloat = (center + (CGFloat(rightOrLeft) * (obstacleCenter.size.width / 2.0)))
        let x: CGFloat = ((tmp - CGFloat(rightOrLeft * 40)) + xOffset)
        greenLight.position = CGPoint(x: x, y: obstacleCenter.position.y)
        greenLight.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        greenLight.physicsBody?.categoryBitMask = CollisionType.pointyWall.rawValue
        greenLight.physicsBody?.collisionBitMask = 0
        greenLight.physicsBody?.affectedByGravity = false
        let obstacleLeft = Wall(spriteTexture: (imageAtlas?.textureNamed("SolidWall"))!, with: CGSize(width: 600.0, height: 60.0))
        obstacleLeft.position = CGPoint(x: CGFloat(-300), y: 1400.0)
        var leftObstacleEndPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
        if rightOrLeft == -1 {
            leftObstacleEndPoint = CGPoint(x: (obstacleCenter.position.x - (obstacleCenter.size.width / 2.0) - CGFloat(ScaleUtil.kObstacleHorizSpace) - (obstacleLeft.size.width / 2.0)), y: 1200.0)
        }
        else {
            leftObstacleEndPoint = CGPoint(x: CGFloat((obstacleCenter.position.x - (obstacleCenter.size.width / 2.0)) - (obstacleLeft.size.width / 2.0)), y: 1400.0)

        }
        let obstacleRight = Wall(spriteTexture: (imageAtlas?.textureNamed("SolidWall"))!, with: CGSize(width: 600.0, height: 60.0))
        obstacleRight.position = CGPoint(x: 940.0, y: 1400.0)
        var rightObstacleEndPoint: CGPoint
        if rightOrLeft == 1 {
            rightObstacleEndPoint = CGPoint(x: CGFloat((obstacleCenter.position.x + (obstacleCenter.size.width / 2.0)) + ScaleUtil.kObstacleHorizSpace + (obstacleRight.size.width / 2.0)), y: 1400.0)
        }
        else {
            rightObstacleEndPoint = CGPoint(x: CGFloat((obstacleCenter.position.x + (obstacleCenter.size.width / 2)) + (obstacleRight.size.width / 2)), y: 1400.0)
        }
        world?.addChild(obstacleCenter)
        world?.addChild(greenLight)
        world?.addChild(obstacleLeft)
        world?.addChild(obstacleRight)
        self.obstacles.append(obstacleCenter)
        self.obstacles.append(greenLight)
        self.obstacles.append(obstacleLeft)
        self.obstacles.append(obstacleRight)
        obstacleLeft.run(SKAction.moveTo(x: leftObstacleEndPoint.x, duration: 1.0))
        obstacleRight.run(SKAction.moveTo(x: rightObstacleEndPoint.x, duration: 1.0))
        playSlidingMetalSound()
    }

// MARK: touch Events

// MARK: UPDATE
    override func update(_ currentTime: CFTimeInterval) {
        super.update(currentTime)
        if !isGameOver && isGameStarted {
            var objectsToRemove = [SKSpriteNode]()
            currentDistanceBetweenObstacles = CGFloat(Float(self.currentDistanceBetweenObstacles) + Float(ScaleUtil.kSpeed) + (Float(stage) * Float(ScaleUtil.kSpeedBoost)))
            var isScraping: Bool = false
            let contacts: [SKPhysicsBody]? = spaceShip?.physicsBody?.allContactedBodies()
            for contact: SKPhysicsBody in contacts! {
                if (contact.categoryBitMask & CollisionType.wall.rawValue) != 0 {
                    isScraping = true
                }
            }
            if isScraping {
                if (spaceShip?.position.x)! > 100.0 {
                    spaceShip?.scrape(scrapeDirection: .scrapeRight)
                }
                else {
                    spaceShip?.scrape(scrapeDirection: .scrapeLeft)
                }
            }
            else {
                spaceShip?.stopScrape()
            }
            if currentDistanceBetweenObstacles >= ScaleUtil.kObstacleVertSpace && !isMovingFasterDisplay {
                currentDistanceBetweenObstacles = 0
                addNewObstacle()
            }
            for obstacle: SKSpriteNode in self.obstacles {
                let currentPos: CGPoint = obstacle.position
                var xAdjustment: CGFloat = 0
                if (obstacle is AlienShip) {
                    if obstacle.position.y - 200.0 < spaceShipY {
                        let alienShip: AlienShip? = (obstacle as? AlienShip)
                        if !(alienShip?.isHasPlayedWhoosh)! {
                            alienShip?.playSound()
                        }
                    }
                }
                if (obstacle is Meteor) {
                    let meteor: Meteor? = (obstacle as? Meteor)
                    xAdjustment = (meteor?.xSpeed)!
                    if obstacle.position.y - 200.0 < spaceShipY {
                        if !(meteor?.isHasPlayedWhoosh)! {
                            meteor?.playSound()
                        }
                    }
                }
                /*if([obstacle isKindOfClass: [RotatingWall class]])
                             {
                             RotatingWall *rotatingWall = (RotatingWall*) obstacle;
                             
                             if(obstacle.position.y -600 < self.spaceShipY)
                             {
                             if(!rotatingWall.hasPlayedWhoosh)
                             {
                             [rotatingWall playSound];
                             }
                             }
                             }*/
                obstacle.position = CGPoint(x: CGFloat(currentPos.x + xAdjustment), y: ((currentPos.y - ScaleUtil.kSpeed) - (CGFloat(stage) * ScaleUtil.kSpeedBoost)))
                // REMOVE WHEN OFF SCREEN
                if (obstacle.position.y + obstacle.size.height) < 0 {
                    obstacle.removeFromParent()
                    objectsToRemove.append(obstacle)
                }
            }
            // remove outside of the for loop
            //FIX THIS NEXT LINE
            //self.obstacles.removeObjects(in: objectsToRemove)
        }
    }

// MARK: Collision Detection
    func didBegin(_ contact: SKPhysicsContact) {
        if isGameOver {
            return
        }
        
        let isCrash: Bool? = CommonScene.isCrash(contact)
        
            // 1
        var firstBody: SKPhysicsBody?
        var secondBody: SKPhysicsBody?
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if (secondBody?.categoryBitMask)! > 1000 {
            return
        }

        if isCrash ?? false {
            //insantiate new explosion on contact
            let ex: SKEmitterNode? = CommonScene.newExplosion()
            world?.addChild(ex!)
            isGameOver = true
            //set the position of contact
            ex?.position = (firstBody?.node?.position)!
            // Get random value between 0 and 1 to determine direction ships spins
            var spinDir: Float = (Float(arc4random() % 2))
            if spinDir == 0 {
                spinDir = -1.0
            }
            let fadeAction = SKAction.fadeOut(withDuration: 0.5)
            //  AlphaTo:0.0f duration:1.0f];
            let spinAction = SKAction.rotate(byAngle: CGFloat(spinDir * .pi * 3), duration: 0.5)
            let blockAction: SKAction? = restartActionBlock()
            let animAction = SKAction.sequence([SKAction.group([self.explosionAction!, fadeAction, spinAction]), blockAction!])
            spaceShip?.rockettrail?.removeFromParent()
            spaceShip?.run(animAction)
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
    }

    func restartActionBlock() -> SKAction {
        //Stop playing sounds
        //AppDelegate *appDelegate= (AppDelegate*) [[UIApplication sharedApplication] delegate];
        //[appDelegate.sharedActions stopAllSounds];
        spaceShip?.stopScrape()
        for object : SKSpriteNode in self.obstacles {
            object.removeFromParent()
        }
        self.obstacles.removeAll()
        let defaults = UserDefaults.standard
        isGameStarted = false
        isGameOver = true
            //appDelegate.lastScore=self.score - 1;
            //appDelegate.gamesPlayed++;
        let highScore: Int? = defaults.integer(forKey: "HighScore")
        lastScore = score
        // Wasnt recorded before so this is a new high
        if highScore != nil || highScore! < (score) {
            defaults.set((score), forKey: "HighScore")
            defaults.synchronize()
            //DONT THINK WE NEED THIS HERE
            highLabel?.text = "Best:\(lastScore)"
        }
            // [appDelegate submitScore];
        let blockAction = SKAction.run({() -> Void in
                self.load()
                //doorsCloseVerticalWithDuration:0.5f]];
            })
        return blockAction
    }

}

