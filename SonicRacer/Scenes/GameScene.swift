//
//
//  MyScene.h
//  SonicRacer
//
//  Copyright (c) 2014 Dave Butler. All rights reserved.
//
//
//  MyScene.m
//  SonicRacer
//
//  Created by Dave Butler on 6/10/14.
//  Copyright (c) 2014 Dave Butler. All rights reserved.
//

import AVFoundation
import CoreMotion
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var isGameStarted: Bool = false
    var spaceShip: SpaceShip?
    var obstacles = [SKSpriteNode]()
    var isGameOver: Bool = false
    var world: SKNode?
    var currentDistanceBetweenObstacles: CGFloat = 0.0
    var spaceShipY: CGFloat = 0
    var explosionAction: SKAction?
    weak var touch: UITouch?
    var targetPosition = CGPoint.zero
    var scoreLabel: SKLabelNode?
    var highLabel: SKLabelNode?
    var score: Int = 0
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
    var leaderBoardButton: SpriteButton?
    var moreStuffButton: SpriteButton?
    var rateItButton: SpriteButton?
    var titleFlashAction: SKAction?
    var titleFlashRepeatAction: SKAction?
    var lastScoreLabel: SKLabelNode?
    var shareButton: SpriteButton?
    //Credit Screen
    var creditBackground: SKSpriteNode?
    var creditsImage: SKSpriteNode?
    var exitCreditButton: SpriteButton?
    var ltmButton: SpriteButton?
    var ltmButton2: SpriteButton?
    var ltmLabel: SKLabelNode?
    var otherGamesLabel: SKLabelNode?
    var isCreditScreenOn: Bool = false

    override init(size: CGSize) {
        super.init(size: size)

        if imageAtlas == nil {
            // Load the atlas that contains the sprites
            imageAtlas = SKTextureAtlas.init(named: "images")
        }
        isCreditScreenOn = false
        score = 0
        if UI_USER_INTERFACE_IDIOM() == .pad {
            spaceShipY = 380
        }
        else {
            if IS_WIDESCREEN {
                spaceShipY = 400
            }
            else {
                spaceShipY = 330
            }
        }
        stage = 0
        isShouldUpdateScore = true
        isGameStarted = false
        isGameOver = false
        currentDistanceBetweenObstacles = 0
        //Set Background Center Pt
        //self.background.position = [ScaleUtil getGameSceneCenterPoint: self.frame];
        // Add a node for the world - this is where sprites and tiles are added
        world = SKNode.init() //node
        world?.position = ScaleUtil.positionGameScene()
        backgroundColor = SKColor.black
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: CGFloat(frame.origin.x), y: CGFloat(frame.origin.y - 220), width: CGFloat(frame.size.width), height: CGFloat(frame.size.height + 1300)))
        
        spaceShip = SpaceShip(spriteTexture: (imageAtlas?.textureNamed("Fighter_90X90"))!)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            spaceShip?.position = CGPoint(x: CGFloat((self.size.width / 2) - 90), y: CGFloat(spaceShipY))
        }
        else {
            if IS_WIDESCREEN {
                spaceShip?.position = CGPoint(x: CGFloat((self.size.width / 2) - 20), y: CGFloat(spaceShipY))
            }
            else {
                spaceShip?.position = CGPoint(x: CGFloat((self.size.width / 2) - 40), y: CGFloat(spaceShipY))
            }
        }
        //self.spaceShip.rockettrail.targetNode = self.scene;
        world?.addChild(spaceShip!)
            /////  **************     960*640 = Playable AREA   *********
        let wallLeft = SKSpriteNode(texture: imageAtlas?.textureNamed("WallLeft"))
        wallLeft.size = CGSize(width: 120.0, height: 2400.0)
            //wallLeft.anchorPoint = CGPointMake(1, 0);
        let leftWallBasePoint = CGPoint(x: -70.0, y: 0.0)
        wallLeft.position = leftWallBasePoint
        wallLeft.physicsBody = SKPhysicsBody.init(rectangleOf: wallLeft.size)
        wallLeft.zPosition = 4
        //Bring to Front
        wallLeft.physicsBody?.isDynamic = false
        wallLeft.physicsBody?.affectedByGravity = false
        wallLeft.physicsBody?.categoryBitMask = CollisionType.wall.rawValue
        wallLeft.physicsBody?.contactTestBitMask = 0
        wallLeft.physicsBody?.collisionBitMask = CollisionType.player.rawValue
        wallLeft.zPosition = 200
        let wallRight = SKSpriteNode(texture: imageAtlas?.textureNamed("WallRight"))
        wallRight.size = CGSize(width: 120.0, height: 2400.0)
        wallRight.zPosition = 4
            //Bring to Front
        let rightWallBasePoint = CGPoint(x: 678.0, y: 0.0)
        wallRight.position = rightWallBasePoint
        wallRight.physicsBody = SKPhysicsBody.init(rectangleOf: wallRight.size)
        wallRight.physicsBody?.isDynamic = false
        wallRight.physicsBody?.affectedByGravity = false
        wallRight.physicsBody?.categoryBitMask = CollisionType.wall.rawValue
        wallRight.physicsBody?.contactTestBitMask = 0
        wallRight.physicsBody?.collisionBitMask = CollisionType.player.rawValue
        wallRight.zPosition = 200
        world?.addChild(wallLeft)
        world?.addChild(wallRight)
        movingMetalSoundAction = SKAction.playSoundFileNamed("040274362-robot-mech-servo-movement-02.m4a", waitForCompletion: true)
        obstacles = [SKSpriteNode]()
        addNewObstacle()
        let background = CommonScene.getBackgroundEmitter()
        background!.position = ScaleUtil.getGameSceneCenterPoint((scene?.frame)!)
        background!.xScale = 1.0
        background!.yScale = 1.0
        background!.zPosition = -1
        world?.addChild(background!)
        physicsWorld.contactDelegate = self
        explosionAction = SKAction.playSoundFileNamed("008745928-explosiondistant.m4a", waitForCompletion: false)
        if scoreLabel == nil {
            setupScoreBoard()
        }
        setupMainMenu()
        scoreLabel?.text = "0"
        let defaults = UserDefaults.standard
        let highScore: Int = defaults.integer(forKey: "HighScore")
        // Wasnt recorded before so this is a new high

        highLabel?.text = "\(NSLocalizedString("Best", comment: "Best high score label")):\(Int(highScore))"
        stageLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        stageLabel?.fontSize = 72
        stageLabel?.fontColor = SKColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.6)
        stageLabel?.horizontalAlignmentMode = .center
        stageLabel?.text = NSLocalizedString("STAGE", comment: "STAGE Label")
        stageLabel?.position = CGPoint(x: 900.0, y: CGFloat(self.size.height / 2 + 200))
        fasterLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        fasterLabel?.fontSize = 72
        fasterLabel?.fontColor = SKColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.6)
        fasterLabel?.horizontalAlignmentMode = .center
        fasterLabel?.text = NSLocalizedString("GOING FASTER", comment: "GOING FASTER Label")
        fasterLabel?.position = CGPoint(x: 900.0, y: CGFloat(self.size.height / 2 + 100))
        fasterAction = SKAction.sequence([SKAction.moveTo(x: (scene?.size.width)! / 2, duration: 0.5), SKAction.wait(forDuration: 1.2), SKAction.moveTo(x: -400, duration: 0.5)])
        addChild(scoreLabel!)
        addChild(highLabel!)
        addChild(world!)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: MENUS / SCOREBOARD
    func setupScoreBoard() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel?.fontSize = 48
        scoreLabel?.fontColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
        scoreLabel?.horizontalAlignmentMode = .right
        highLabel = SKLabelNode(fontNamed: "Chalkduster")
        //]@"Menlo-Bold"];
        highLabel?.fontSize = 48
        highLabel?.fontColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
        highLabel?.horizontalAlignmentMode = .left
        if UI_USER_INTERFACE_IDIOM() == .pad {
            highLabel?.position = CGPoint(x: 80.0, y: 950.0)
            scoreLabel?.position = CGPoint(x: CGFloat(690), y: 950.0)
        }
        else {
            if IS_WIDESCREEN {
                highLabel?.position = CGPoint(x: 20.0, y: 1060.0)
                scoreLabel?.position = CGPoint(x: 600.0, y: 1060.0)
            }
            else {
                highLabel?.position = CGPoint(x: 70.0, y: 890.0)
                scoreLabel?.position = CGPoint(x: 640.0, y: 890.0)
            }
        }
    }

    func setupMainMenu() {
        let appDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        if titleLabel == nil {
            titleLabel = SKLabelNode(fontNamed: "Menlo-Bold")
            titleLabel?.fontColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            titleLabel?.horizontalAlignmentMode = .center
            titleLabel?.position = CGPoint(x: CGFloat(size.width / 2), y: CGFloat((size.height / 2) + 80))
            let sonicString = NSLocalizedString("Sonic Racer", comment: "Sonic Racer")
            if (sonicString.characters.count ) >= 13 {
                titleLabel?.fontSize = 48
            }
            else {
                titleLabel?.fontSize = 84
            }
            titleLabel?.text = sonicString
            tapToPlayLabel = SKLabelNode(fontNamed: "Menlo-Bold")
            if (sonicString.characters.count ) > 13 {
                tapToPlayLabel?.fontSize = 28
            }
            else {
                tapToPlayLabel?.fontSize = 48
            }
            tapToPlayLabel?.fontColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
            tapToPlayLabel?.horizontalAlignmentMode = .center
            tapToPlayLabel?.position = CGPoint(x: CGFloat(size.width / 2), y: CGFloat(size.height / 2))
            tapToPlayLabel?.text = NSLocalizedString("TAP TO START", comment: "TAP TO START")
            swipeToMoveLabel = SKLabelNode(fontNamed: "Menlo-Bold")
            swipeToMoveLabel?.fontSize = 18
            swipeToMoveLabel?.fontColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
            swipeToMoveLabel?.horizontalAlignmentMode = .center
            swipeToMoveLabel?.position = CGPoint(x: CGFloat(size.width / 2), y: CGFloat((size.height / 2) - 40))
            swipeToMoveLabel?.text = "<--------- \(NSLocalizedString("swipe to move", comment: "swipe to move label")) --------->"
            lastScoreLabel = SKLabelNode(fontNamed: "Menlo-Bold")
            lastScoreLabel?.fontSize = 48
            lastScoreLabel?.fontColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
            lastScoreLabel?.horizontalAlignmentMode = .center
            lastScoreLabel?.position = CGPoint(x: CGFloat((size.width / 2)), y: CGFloat((size.height / 2) + 200))
            if (appDelegate?.gamesPlayed)! > 2 {
                rateItButton = self.createSpriteButtonNamed(named: "RateIt", withText: NSLocalizedString("RATE IT", comment: "RATE IT"), selector: #selector(self.rateItButtonPressed), fontSize: 64.0, fontColor: UIColor.gray, fontName: "Menlo-Bold")

                rateItButton?.position = CGPoint(x: CGFloat((size.width / 2)), y: CGFloat((size.height / 2) - 100))
                addChild(rateItButton!)
            }
            leaderBoardButton = self.createSpriteButtonNamed(named: "LeaderBoard", withText: NSLocalizedString("LeaderBoard", comment: "LeaderBoard"), selector: #selector(self.leaderBoardButtonPressed))
            moreStuffButton = self.createSpriteButtonNamed(named: "More", withText: NSLocalizedString("More", comment: "More"), selector: #selector(self.moreButtonPressed))

            shareButton = self.createSpriteButtonNamed(named: "Share", withText: NSLocalizedString("SHARE", comment: "SHARE"), selector: #selector(self.shareButtonPressed), fontSize: 48.0, fontName: "Menlo-Bold")

            
            shareButton?.position = CGPoint(x: CGFloat((size.width / 2)), y: CGFloat((size.height / 2) + 290))
            //[self.shareButton.title setFontColor: [SKColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:0.6]];
            
            //self.leaderBoardButton.title.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
            //self.moreStuffButton.title.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
            if UI_USER_INTERFACE_IDIOM() == .pad {
                leaderBoardButton?.position = CGPoint(x: 200.0, y: 50.0)
                moreStuffButton?.position = CGPoint(x: 645.0, y: 50.0)
            }
            else {
                if IS_WIDESCREEN {
                    leaderBoardButton?.position = CGPoint(x: CGFloat(140), y: 50.0)
                    moreStuffButton?.position = CGPoint(x: CGFloat(560), y: 50.0)
                }
                else {
                    leaderBoardButton?.position = CGPoint(x: CGFloat(160), y: 50.0)
                    moreStuffButton?.position = CGPoint(x: 600.0, y: 50.0)
                }
            }
        }
        addChild(titleLabel!)
        addChild(swipeToMoveLabel!)
        addChild(leaderBoardButton!)
        addChild(tapToPlayLabel!)
        addChild(moreStuffButton!)
        if (appDelegate?.lastScore)! > 0 {
            lastScoreLabel?.text = "\(NSLocalizedString("YOUR SCORE", comment: "YOUR SCORE label")): \(Int((appDelegate?.lastScore)!))" //"  (String(describing: appDelegate?.lastScore))"
            addChild(lastScoreLabel!)
            addChild(shareButton!)
        }
        // [self.titleLabel runAction: self.titleFlashRepeatAction withKey:@"flash"];
    }

    //couldnt find a transition to do this so simulate a modal translucent window
    func setupCreditScreen() {
        if creditBackground == nil {
            creditBackground = SKSpriteNode(color: SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.85), size: self.size)
            creditBackground?.zPosition = 10
            creditBackground?.position = CGPoint(x: self.size.width / 2.0, y: self.size.height / 2.0)
            creditsImage = SKSpriteNode(imageNamed: "Credits")
            creditsImage?.zPosition = 12
            var pt = CGPoint(x: (self.frame.size.width / 2.0) + 15.0, y: (self.frame.size.height / 2.0) + 140.0)
            pt.y = pt.y + 40
            pt.x = pt.x - 15
            creditsImage?.position = pt
            exitCreditButton = self.createSpriteButtonNamed(named: "creditButton", withText: "", imageNamed: "X", selector: #selector(self.exitCreditButtonPressed))

            exitCreditButton?.zPosition = 12
            
            ltmButton = self.createSpriteButtonNamed(named: "ltmButton", withText: "", imageNamed: "LabyrinthTiltMaze", selector: #selector(self.ltmButtonPressed))
            
            ltmButton2 = self.createSpriteButtonNamed(named: "ltmButton2", withText: "", imageNamed: "LTM_ScreenShot", selector: #selector(self.ltmButtonPressed))

            ltmButton?.zPosition = 12
            ltmButton2?.zPosition = 12
            
            otherGamesLabel = SKLabelNode(fontNamed: "Menlo-Bold")
            otherGamesLabel?.fontSize = 48
            otherGamesLabel?.zPosition = 12
            otherGamesLabel?.fontColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            otherGamesLabel?.horizontalAlignmentMode = .center
            otherGamesLabel?.position = CGPoint(x: size.width / 2, y: (size.height / 2) - 40)
            otherGamesLabel?.text = "---------------------- \(NSLocalizedString("OTHER GAMES BY", comment: "OTHER GAMES BY")) DAVE ----------------------"
            ltmLabel = SKLabelNode(fontNamed: "Menlo-Bold")
            ltmLabel?.fontSize = 36
            ltmLabel?.zPosition = 12
            ltmLabel?.fontColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            ltmLabel?.horizontalAlignmentMode = .center
            ltmLabel?.position = CGPoint(x: CGFloat(size.width / 2), y: CGFloat((size.height / 2) - 100))
            ltmLabel?.text = NSLocalizedString("Labyrinth Tilt Maze", comment: "Labyrinth Tilt Maze")
            if UI_USER_INTERFACE_IDIOM() == .pad {
                ltmButton?.position = CGPoint(x: CGFloat(210), y: 250.0)
                ltmButton2?.position = CGPoint(x: CGFloat(550), y: 250.0)
                exitCreditButton?.position = CGPoint(x: 645.0, y: 910.0)
            }
            else {
                if IS_WIDESCREEN {
                    ltmButton?.position = CGPoint(x: CGFloat(150), y: 250.0)
                    ltmButton2?.position = CGPoint(x: CGFloat(490), y: 250.0)
                    exitCreditButton?.position = CGPoint(x: 580.0, y: 960.0)
                }
                else {
                    ltmButton?.position = CGPoint(x: CGFloat(180), y: 250.0)
                    ltmButton2?.position = CGPoint(x: 520.0, y: 250.0)
                    exitCreditButton?.position = CGPoint(x: 600.0, y: 890.0)
                }
            }
        }
        addChild(creditBackground!)
        //[self.creditBackground runAction: [SKAction fadeToAlpha: -0.9 duration: 0.5]];
        addChild(creditsImage!)
        addChild(exitCreditButton!)
        addChild(ltmButton!)
        addChild(ltmButton2!)
        addChild(ltmLabel!)
        addChild(otherGamesLabel!)
        isCreditScreenOn = true
        // [self.titleLabel runAction: self.titleFlashRepeatAction withKey:@"flash"];
    }

    func removeMainMenu() {
        titleLabel?.removeFromParent()
        swipeToMoveLabel?.removeFromParent()
        leaderBoardButton?.removeFromParent()
        tapToPlayLabel?.removeFromParent()
        moreStuffButton?.removeFromParent()
        shareButton?.removeFromParent()
        lastScoreLabel?.removeFromParent()
        if rateItButton != nil {
            rateItButton?.removeFromParent()
        }
    }

    func removeCreditScreen() {
        creditBackground?.removeFromParent()
        creditsImage?.removeFromParent()
        exitCreditButton?.removeFromParent()
        ltmLabel?.removeFromParent()
        ltmButton?.removeFromParent()
        ltmButton2?.removeFromParent()
        otherGamesLabel?.removeFromParent()
    }

// MARK: Buttons
    func ltmButtonPressed() {
            //NSString *appName = [NSString stringWithString:[[[NSBundle mainBundle] infoDictionary]   objectForKey:@"CFBundleName"]];
            //Commented line give URL for this app
            //NSURL *appStoreURL = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.com/app/%@",[appName stringByReplacingOccurrencesOfString:@" " withString:@""]]];
        let appStoreURL = URL(string: "https://itunes.apple.com/app/id867366250")
        //[NSString stringWithFormat:@"itms-apps://itunes.com/app/%@",@"labyrinthtiltmaze"]];
        //https://itunes.apple.com/app/id867366250
        UIApplication.shared.openURL(appStoreURL!)
    }

    func rateItButtonPressed() {
        let appStoreURL = URL(string: "https://itunes.apple.com/app/id894446179")
        UIApplication.shared.openURL(appStoreURL!)
    }

    func leaderBoardButtonPressed() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "presentLeaderboards"), object: nil)
        //Sends message to viewcontroller to show more screen.
    }

    func moreButtonPressed() {
        setupCreditScreen()
    }

    func exitCreditButtonPressed() {
        isCreditScreenOn = false
        removeCreditScreen()
    }

    func shareButtonPressed() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "share"), object: nil)
        //Sends message to viewcontroller to share score.
    }

    func createSpriteButtonNamed(named name: String, withText text: String, imageNamed imageName: String?="clear", selector: Selector, fontSize: CGFloat? = 32.0, fontColor: UIColor?=UIColor.gray, fontName: String? = "Chalkduster") -> SpriteButton {
        
        let fontName=fontName
        let fontSize=fontSize
        let fontColor=fontColor
        
        
        let texture: SKTexture! = SKTexture.init(imageNamed: imageName!)

        let button: SpriteButton = SpriteButton(normalTexture: texture, selectedTexture: texture, disabledTexture: texture)

        button.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        button.setButtonAction(target: self, triggerEvent: .TouchUpInside, action:selector)
        button.zPosition=1
        button.name=name
        
        
        button.setButtonLabel(title: text as NSString, font: fontName!, fontSize: fontSize!, fontColor: fontColor!)

        if imageName=="clear"
        {
            button.size=CGSize(width: 400.0, height: 80.0)
        }
        //button.title?.fontColor = SKColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.6)
        //button.color = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.01)
        //button.title?.fontSize = 32.0
        return button
    }



// MARK: Obstacles
    func addNewObstacle() {
        if isShouldUpdateScore {
            scoreLabel?.text = "\(score)"
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
            addChild(stageLabel!)
            addChild(fasterLabel!)
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
        //obstacleType = ObstacleType.pointyWallObstacle;
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
            let rotatingWall = RotatingWall.init(spriteTextureAtlas: imageAtlas!)
            var intersects: Bool = true
            while intersects {
                let wallPosition = CGPoint(x: CGFloat(CommonScene.randomValueBetween(low: Float(ScaleUtil.kMinWidth), andValue: Float(ScaleUtil.kMaxWidth * 2))), y: CGFloat(950 + (i * 350)))
                rotatingWall.position = wallPosition
                //Make sure we didnt just place it ontop of anotehr ship
                if rotatingWall.physicsBody?.allContactedBodies().count == 0 {
                    intersects = false
                }
            }
            world?.addChild(rotatingWall)
            obstacles.append(rotatingWall)
        }
    }

    
    func playSlidingMetalSound() {
        run(movingMetalSoundAction!)
    }

    func addMeteorObstacles() {
        //Generate 5 ships at random positions
        for i in 1...6 {
            let meteor = Meteor.init(spriteTextureAtlas: imageAtlas!)
            var intersects: Bool = true
            while intersects {
                let meteorPosition = CGPoint(x: CGFloat(CommonScene.randomValueBetween(low: Float(ScaleUtil.kMinWidth - 200), andValue: Float((ScaleUtil.kMaxWidth + 200) * 2))), y: CGFloat(CommonScene.randomValueBetween(low: 1150, andValue: 1780)))
                meteor.position = meteorPosition
                //Make sure we didnt just place it ontop of anotehr ship
                if meteor.physicsBody?.allContactedBodies().count == 0 {
                    intersects = false
                }
            }
            world?.addChild(meteor)
            obstacles.append(meteor)
        }
    }

    func addAlienShipObstacles() {
        //Generate 5 ships at random positions
        for i in 1...4 {
            let alienShip = AlienShip.init(spriteTextureAtlas: imageAtlas!)
            var intersects: Bool = true
            while intersects {
                let alienShipPosition = CGPoint(x: CGFloat(CommonScene.randomValueBetween(low: Float(ScaleUtil.kMinWidth), andValue: Float(ScaleUtil.kMaxWidth * 2))), y: CGFloat(CommonScene.randomValueBetween(low: 1150, andValue: 1780)))
                alienShip.position = alienShipPosition
                //Make sure we didnt just place it ontop of anotehr ship
                if alienShip.physicsBody?.allContactedBodies().count == 0 {
                    intersects = false
                }
            }
            world?.addChild(alienShip)
            obstacles.append(alienShip)
        }
    }

    func addPointyWallObstacles() {
        let obstacleRight = ConeWall(spriteTexture: (imageAtlas?.textureNamed("RightPointyWall"))!, with: ConeOrientation.ConeOrientationRight)
            //spriteNodeWithTexture: [self.imageAtlas textureNamed: @"RightPointyWall"]];
        let rightObstacleBasePoint = CGPoint(x: ScaleUtil.kMaxWidth * 2.0, y: 1400.0)
        let rightObstacleEndPoint = CGPoint(x: CGFloat(CommonScene.randomValueBetween(low: Float(ScaleUtil.kMinWidth) + 40, andValue: Float(ScaleUtil.kMaxWidth * 2))), y: 1400.0)
        obstacleRight.position = rightObstacleBasePoint
        let obstacleLeft = ConeWall(spriteTexture: (imageAtlas?.textureNamed("LeftPointyWall"))!, with: ConeOrientation.ConeOrientationLeft)
        obstacleLeft.position = CGPoint(x: 0.0, y: obstacleRight.position.y)
            //CGPointMake(0,0);
        let obstacleLeftEndPoint = CGPoint(x: rightObstacleEndPoint.x - ScaleUtil.kObstacleHorizSpace, y: obstacleRight.position.y)
        world?.addChild(obstacleRight)
        world?.addChild(obstacleLeft)
        obstacles.append(obstacleRight)
        obstacles.append(obstacleLeft)
        obstacleRight.run(SKAction.moveTo(x: rightObstacleEndPoint.x, duration: 1.0))
        obstacleLeft.run(SKAction.moveTo(x: obstacleLeftEndPoint.x, duration: 1.0))
        playSlidingMetalSound()
    }

    func addGreenLightWallObstacles() {
        var xOffset: CGFloat
        if UI_USER_INTERFACE_IDIOM() == .pad {
            xOffset = -75
        }
        else {
            if IS_WIDESCREEN {
                xOffset = -15
            }
            else {
                xOffset = -55
            }
        }
        let obstacleCenter = Wall(spriteTexture: (imageAtlas?.textureNamed("SolidWall"))!, with: CGSize(width: CGFloat(CommonScene.randomValueBetween(low: 100, andValue: 450)), height: 60.0))
        obstacleCenter.position = CGPoint(x: CGFloat(((scene?.size.width)! / 2) + xOffset), y: 1400.0)
        let greenLight = SKSpriteNode(texture: imageAtlas?.textureNamed("GreenLight109X109"))
        // leave room for 150 space
        greenLight.size = CGSize(width: CGFloat(40), height: CGFloat(40))
        greenLight.zPosition = 12
        
        // Get random value between 0 and 1 to determine what type of obstaccle we get 0 = Left 1 = Right
        var rightOrLeft: Int = Int(Float(arc4random() % 2))
        if rightOrLeft == 0 {
            rightOrLeft = -1
        }
        
        let center = ((scene?.size.width)! / 2)
        let displacement = (CGFloat(rightOrLeft) * (obstacleCenter.size.width / 2) - (CGFloat(rightOrLeft) * 40)) + xOffset
        
        greenLight.position = CGPoint(x: CGFloat(center + displacement), y: CGFloat(obstacleCenter.position.y))
        greenLight.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        greenLight.physicsBody?.categoryBitMask = CollisionType.pointyWall.rawValue
        greenLight.physicsBody?.collisionBitMask = 0
        greenLight.physicsBody?.affectedByGravity = false
        let obstacleLeft = Wall(spriteTexture: (imageAtlas?.textureNamed("SolidWall"))!, with: CGSize(width: 600.0, height: 60.0))
        obstacleLeft.position = CGPoint(x: CGFloat(-300), y: 1400.0)
        var leftObstacleEndPoint: CGPoint
        if rightOrLeft == -1 {
            leftObstacleEndPoint = CGPoint(x: CGFloat((obstacleCenter.position.x - (obstacleCenter.size.width / 2)) - ScaleUtil.kObstacleHorizSpace - (obstacleLeft.size.width / 2)), y: 1400.0)
        }
        else {
            leftObstacleEndPoint = CGPoint(x: CGFloat((obstacleCenter.position.x - (obstacleCenter.size.width / 2)) - (obstacleLeft.size.width / 2)), y: 1400.0)
        }
        let obstacleRight = Wall(spriteTexture: (imageAtlas?.textureNamed("SolidWall"))!, with: CGSize(width: 600.0, height: 60.0))
        obstacleRight.position = CGPoint(x: CGFloat(940), y: 1400.0)
        var rightObstacleEndPoint: CGPoint
        if rightOrLeft == 1 {
            rightObstacleEndPoint = CGPoint(x: CGFloat((obstacleCenter.position.x + (obstacleCenter.size.width / 2)) + ScaleUtil.kObstacleHorizSpace + (obstacleRight.size.width / 2)), y: 1400.0)
        }
        else {
            rightObstacleEndPoint = CGPoint(x: CGFloat((obstacleCenter.position.x + (obstacleCenter.size.width / 2)) + (obstacleRight.size.width / 2)), y: 1400.0)
        }
        world?.addChild(obstacleCenter)
        world?.addChild(greenLight)
        world?.addChild(obstacleLeft)
        world?.addChild(obstacleRight)
        obstacles.append(obstacleCenter)
        obstacles.append(greenLight)
        obstacles.append(obstacleLeft)
        obstacles.append(obstacleRight)
        obstacleLeft.run(SKAction.moveTo(x: leftObstacleEndPoint.x, duration: 1.0))
        obstacleRight.run(SKAction.moveTo(x: rightObstacleEndPoint.x, duration: 1.0))
        playSlidingMetalSound()
    }

// MARK: touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveImage(forTouches: touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveImage(forTouches: touches)
    }

    func moveImage(forTouches touches: Set<AnyHashable>) {
        let touch: UITouch? = touches.first as? UITouch
        let location: CGPoint? = touch?.location(in: view)
        if isCreditScreenOn {
            return
        }
        if (scene?.frame.contains(location!))! {
            if !isGameStarted {
                removeMainMenu()
                isGameStarted = true
                spaceShip?.physicsBody?.isDynamic = true
            }
            let point: CGPoint? = touch?.location(in: nil)
            //        NSLog(@"Y=%f", y);
            // NO CLUE WHY I NEEDED THIS IF STATEMENT, for some reason I needed to multiply iPhone *2.  Its not a retina thing because this works fine on the iPad retina.
            if UI_USER_INTERFACE_IDIOM() == .pad {
                var y: CGFloat? = (1024 - (point?.y)!) + 200.0
                if y! > CGFloat(1000.0) {
                    y = 1000.0
                }
                    //Prevent the ship ship from goign past the physics barier on the right and left side
                var x: CGFloat? = (point?.x)! - 80.0
                if x! < CGFloat(18.0) {
                    x = 25.0
                }
                if x! > CGFloat(585.0) {
                    x = 582.0
                }
                //[self.spaceShip runAction: [SKAction moveTo: CGPointMake(x, self.spaceShipY) duration:0.02]];
                spaceShip?.run(SKAction.move(to: CGPoint(x: CGFloat(x!), y: CGFloat(y!)), duration: 0.02))
            }
            else {
                    //Prevent the ship ship from goign past the physics barier on the right and left side
                var x: CGFloat = ((point?.x)! * 2.0) - 20
                var y: CGFloat = 0
                if IS_WIDESCREEN {
                    y = ((568 - (point?.y)!) * 2) + 200
                    if y > 500 {
                        y = 500
                    }
                }
                else {
                    y = ((460 - (point?.y)!) * 2) + 200
                    if y > 420 {
                        y = 420
                    }
                }
                if x < CGFloat(18.0) {
                    x = 25.0
                }
                if x > 585.0 {
                    x = 582.0
                }
                //[self.spaceShip runAction: [SKAction moveTo: CGPointMake(x, self.spaceShipY) duration:0.02]];
                spaceShip?.run(SKAction.move(to: CGPoint(x: CGFloat(x), y: y), duration: 0.02))
            }
        }
    }

// MARK: UPDATE
    override func update(_ currentTime: CFTimeInterval) {
        super.update(currentTime)
        if !isGameOver && isGameStarted {
            var objectsToRemove = [Any]()
            currentDistanceBetweenObstacles = currentDistanceBetweenObstacles + ScaleUtil.kSpeed + (CGFloat(stage) * ScaleUtil.kSpeedBoost)
            var isScraping: Bool = false

            //for contact: SKPhysicsBody in contacts {
            for object in (spaceShip?.physicsBody?.allContactedBodies())!  {
                // inferred type body: SKPhysicsBody
                let contact = object

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
            for obstacle: SKSpriteNode in obstacles {
                let currentPos: CGPoint = obstacle.position
                var xAdjustment: CGFloat = 0
                if (obstacle is AlienShip) {
                    if obstacle.position.y - 200 < spaceShipY {
                        let alienShip: AlienShip? = (obstacle as? AlienShip)
                        if !(alienShip?.isHasPlayedWhoosh)! {
                            alienShip?.playSound()
                        }
                    }
                }
                if (obstacle is Meteor) {
                    let meteor: Meteor? = (obstacle as? Meteor)
                    xAdjustment = (meteor?.xSpeed)!
                    if obstacle.position.y - 200 < spaceShipY {
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
                obstacle.position = CGPoint(x: CGFloat(currentPos.x + xAdjustment), y: CGFloat((currentPos.y - ScaleUtil.kSpeed) - (CGFloat(stage) * ScaleUtil.kSpeedBoost)))
                // REMOVE WHEN OFF SCREEN
                if (obstacle.position.y + obstacle.size.height) < 0 {
                    obstacle.removeFromParent()
                    objectsToRemove.append(obstacle)
                }
            }
            // remove outside of the for loop
            //FIX THIS
            //obstacles.removeObjects(in: objectsToRemove)
        }
    }

// MARK: Collision Detection
    func didBegin(_ contact: SKPhysicsContact) {
        if isGameOver {
            return
        }
            // 1
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
            let animAction = SKAction.sequence([SKAction.group([explosionAction!, fadeAction, spinAction]), blockAction!])
            spaceShip?.rockettrail?.removeFromParent()
            spaceShip?.run(animAction)
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
    }

    func restartActionBlock() -> SKAction {
            //Stop playing sounds
        let appDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        //[appDelegate.sharedActions stopAllSounds];
        spaceShip?.stopScrape()
        world?.removeChildren(in: obstacles)
        obstacles.removeAll()
        let defaults = UserDefaults.standard
        isGameStarted = false
        isGameOver = true
        appDelegate?.lastScore = score - 1
        appDelegate?.gamesPlayed += 1
        let highScore: Int = defaults.integer(forKey: "HighScore")
        // Wasnt recorded before so this is a new high
        if highScore < (appDelegate?.lastScore)! {
            defaults.set(appDelegate?.lastScore, forKey: "HighScore")
            defaults.synchronize()
            //DONT THINK WE NEED THIS HERE
            //self.highLabel.text = [NSString stringWithFormat:@"Best:%d", appDelegate.lastScore];
        }
        appDelegate?.submitScore()
        let blockAction = SKAction.run({() -> Void in
            let scene: GameScene = GameScene(size: ScaleUtil.getSceneSize())
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.5))
                //doorsCloseVerticalWithDuration:0.5f]];
            })
        return blockAction
    }

}

