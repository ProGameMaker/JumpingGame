//
//  GameScence.swift
//  JumpingGame
//
//  Created by Nguyễn Trí on 9/25/18.
//  Copyright © 2018 Nguyễn Trí. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene : SKScene {
    
    @objc let swipeDownRec = UISwipeGestureRecognizer()
    var IsEnable = false
    
    var mainChar = SKSpriteNode()
    var fireWall = SKSpriteNode()
    var ostacle = SKSpriteNode()
    var bullet = SKSpriteNode()
    var Score = SKLabelNode()
    
    var runningFrame: [SKTexture] = []
    var jumppingFram: [SKTexture] = []
    var ostacleFram: [SKTexture] = []
    var bulletFram: [SKTexture] = []
    var slidingFram: [SKTexture] = []
    
    var touchTime : Int = 0
    var lim : CGFloat = 0
    var score : Double = 0
    var pause : Int = 0
    
    struct PhysicsCategory {
        static let none      : UInt32 = 0
        static let all       : UInt32 = UInt32.max
        static let char   : UInt32 = 0b1       // 1
        static let background : UInt32 = 0b10      // 2
        static let ostacle : UInt32 = UInt32(3)
    }
    
    func createGround() {
        
        let random = 1 + Int(arc4random_uniform(UInt32(3)))
        let ground = SKSpriteNode(imageNamed: "ground-sprite-png-\(random)")
        
        
        let t : CGFloat = ground.size.width/ground.size.height
        ground.size.height = (self.scene?.size.height)!/3;
        ground.size.width = ground.size.height * t;
        
        ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ground.position = CGPoint(x: (self.scene?.size.width)! + ground.size.width/2, y: 0)
        
        // set physic body
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ground.size.width, height: ground.size.height*9/12))
        ground.physicsBody?.isDynamic = true
        ground.physicsBody?.allowsRotation = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.background
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.char
        ground.physicsBody?.collisionBitMask = PhysicsCategory.none
        ground.physicsBody?.usesPreciseCollisionDetection = true
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.restitution = 0
        
        ground.zPosition = -2
        addChild(ground)
        
        let action = SKAction.move(to: CGPoint(x: -ground.size.width,y: 0), duration: Double((ground.position.x + ground.size.width)/400))
        let actionDone = SKAction.removeFromParent()
        ground.run(SKAction.sequence([action,actionDone]))
    }
    
    func CreateChar() {
        
        let charTexture = SKTexture(imageNamed: "Run")
        mainChar = SKSpriteNode(texture: charTexture)
        
        mainChar.size = CGSize(width: self.mainChar.size.width/6, height: self.mainChar.size.height/6)
        mainChar.position = CGPoint(x: (scene?.size.width)!/1.7,y: (scene?.size.height)!/3)
        //mainChar.anchorPoint = CGPoint(x: 0, y: 0)
        
        // set main char physic body
        mainChar.physicsBody = SKPhysicsBody(texture: mainChar.texture!, size: mainChar.frame.size)
        mainChar.physicsBody?.isDynamic = true
        mainChar.physicsBody?.allowsRotation = false
        mainChar.physicsBody?.categoryBitMask = PhysicsCategory.char
        mainChar.physicsBody?.contactTestBitMask = PhysicsCategory.ostacle
        mainChar.physicsBody?.collisionBitMask = PhysicsCategory.ostacle
        //mainChar.physicsBody?.usesPreciseCollisionDetection = true
        mainChar.physicsBody?.affectedByGravity = true
        mainChar.physicsBody?.restitution = 0
        
        mainChar.zPosition = 1
        addChild(mainChar)
    }
    
    func CreateWall() {
        
        //fireWall.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        fireWall = SKSpriteNode(imageNamed: "woodwall")
        fireWall.size = CGSize(width: (scene?.size.width)!/8, height: (scene?.size.height)!)
        fireWall.position = CGPoint(x: fireWall.size.width/2.5, y: fireWall.size.height/2)
        fireWall.zPosition = -1
        
        addChild(fireWall)
    }
    
    func AddObstacle() {
        
        let firstFrameTexture = ostacleFram[0]
        ostacle = SKSpriteNode(texture: firstFrameTexture)
        
        let randomX = (view?.frame.size.width)! * 3/2
        let randomY = (scene?.size.height)!/4 + CGFloat(arc4random_uniform(UInt32(((scene?.size.height)!)/3)))
        
        ostacle.xScale = ostacle.xScale * -1/2
        ostacle.yScale = ostacle.yScale * 1/2
        ostacle.zPosition = -3
        
        ostacle.position = CGPoint(x: randomX, y: randomY);
        addChild(ostacle)
        
        ostacle.physicsBody = SKPhysicsBody(texture: ostacle.texture!, size: CGSize(width: ostacle.size.width, height: ostacle.size.height))
        ostacle.physicsBody?.isDynamic = true // 2
        ostacle.physicsBody?.categoryBitMask = PhysicsCategory.ostacle // 3
        ostacle.physicsBody?.contactTestBitMask = PhysicsCategory.char // 4
        ostacle.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
        ostacle.physicsBody?.affectedByGravity = false
        
        let actionMove = SKAction.move(to: CGPoint(x: -(scene?.size.width)!, y: randomY),duration: Double(randomX + ((scene?.size.width)!))/250)
        let actionMoveDone = SKAction.removeFromParent()
        let fireAction = SKAction.repeatForever(SKAction.sequence([SKAction.run{ self.CreateBullet(PreOstacle: self.ostacle) },SKAction.wait(forDuration: 0.05)]))
        
        let animetion = SKAction.repeatForever(SKAction.animate(with: ostacleFram, timePerFrame: 0.1, resize: false, restore: true))
        
        
        let group = SKAction.group([SKAction.sequence([actionMove,actionMoveDone]),animetion,fireAction])
        
        ostacle.run(group)
        
        //run(SKAction.playSoundFileNamed("helicopter-fly-over-01.mp3", waitForCompletion: false))
    }
    
    func CreateBullet(PreOstacle: SKSpriteNode) {
        
        let bulletTexture = SKTexture(imageNamed: "bullet")
        bullet = SKSpriteNode(texture: bulletTexture)
        
        bullet.position = CGPoint(x: PreOstacle.frame.origin.x, y: PreOstacle.frame.origin.y)
        bullet.xScale /= 5; bullet.yScale /= 5
        bullet.zPosition = -3
        bullet.color = UIColor.black
       
        addChild(bullet)
        
        bullet.physicsBody = SKPhysicsBody(texture: bullet.texture!, size: CGSize(width: bullet.size.width, height: bullet.size.height))
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.ostacle
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.char
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.none
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.affectedByGravity = false
        
        let actionMove = SKAction.move(to: CGPoint(x: bullet.position.x - 150, y: bullet.position.y),duration: 0.3)
        
        let actionMoveDone = SKAction.removeFromParent()
        let group = SKAction.group([SKAction.sequence([actionMove,actionMoveDone])])
        
        bullet.run(group)
        
        run(SKAction.playSoundFileNamed("boulder_impact_from_catapult_or_trebuchet.mp3", waitForCompletion: false))
        
    }
    
    func builAnimation(animationFile: String) -> [SKTexture] {
        
        let AnimatedAtlas = SKTextureAtlas(named: animationFile)
        var Frames: [SKTexture] = []
        
        let numImages = AnimatedAtlas.textureNames.count
        for i in 0...numImages - 1 {
            let TextureName = "\(animationFile)__00\(i)"
            Frames.append(AnimatedAtlas.textureNamed(TextureName))
        }
        
        return Frames
    }
    
    func CreateScore() {
        
        Score.fontName = "YourFontName-Bold"
        Score.fontColor = SKColor.white
        Score.text = String(Int(score))
        Score.position = CGPoint(x: (view?.frame.width)!/2, y: (view?.frame.height)! - (view?.frame.height)!/10)
     
        addChild(Score)
    }
    
    func CreateBackground() {
        
        let background = SKSpriteNode(imageNamed: "Mystic_Ruins_Cutscene_Background")
        background.size = CGSize(width: (scene?.size.width)!, height: (scene?.size.height)!)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.zPosition = -4
        addChild(background)
        
    }
    
    func GameOver() {

        run(SKAction.playSoundFileNamed("43696__notchfilter__game-over01.wav", waitForCompletion: false))
        let reveal = SKTransition.crossFade(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size, score: Int(self.score))
        self.view?.presentScene(gameOverScene, transition: reveal)
    }
    
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0, y: 0)
        pause = 0
        
        // create animation
        ostacleFram = builAnimation(animationFile: "helicopter-sprite-png")
        runningFrame = builAnimation(animationFile: "Run")
        jumppingFram = builAnimation(animationFile: "Jump")
        slidingFram = builAnimation(animationFile: "Slide")
        
        // create object
        CreateScore()
        CreateWall()
        CreateChar()
        CreateBackground()
        
        // create swipDown
        swipeDownRec.addTarget(self, action: #selector(slide) )
        swipeDownRec.direction = .down
        self.view!.addGestureRecognizer(swipeDownRec)
        
        // set infinity ground
        let action1 = SKAction.repeatForever(SKAction.sequence([SKAction.run(createGround),SKAction.wait(forDuration: 2.5)]))
        let action2 = SKAction.repeatForever(SKAction.animate(with: runningFrame, timePerFrame: 0.1, resize: false, restore: true))
        let action3 = SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 2.5),SKAction.run(AddObstacle)]))
        
        let action = SKAction.group([action1,action2,action3])
        
        //set physic
        physicsWorld.gravity.dy = CGFloat(-3)
        physicsWorld.contactDelegate = self
        physicsBody?.restitution = 0
        
        //add music
        let backgroundMusic = SKAudioNode(fileNamed: "Chase.mp3")
        backgroundMusic.autoplayLooped = true
        //backgroundMusic.run(SKAction.changeVolume(by: Float(0.1), duration: 0))
        addChild(backgroundMusic)
        
        mainChar.run(action)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // if sliding no running
        if (IsEnable) {return}
        
        if (touchTime < 2) {
            
        run(SKAction.playSoundFileNamed("126416__cabeeno-rossley__jump", waitForCompletion: false))
            
            mainChar.removeAction(forKey: "Jumpping")
            
            touchTime += 1;
            let action1 = SKAction.moveTo(y: mainChar.position.y + 200, duration: 0.5)
            let action2 = SKAction.animate(with: jumppingFram, timePerFrame: 0.15, resize: false, restore: true)
            let action3 = SKAction.moveTo(y: mainChar.position.y - 200, duration: 1)
            
            let action = SKAction.group([SKAction.sequence([action1,action3]),action2])
            mainChar.run(action, withKey: "Jumpping")
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        
        if mainChar.position.y < 0 || mainChar.position.x < fireWall.size.width { GameOver() }
    
        score += 0.1
        Score.text = String(Int(score))
        Score.fontColor = UIColor.black
   
        //if ostacle.intersects(mainChar) {exit(0)}
        
    }
    
    @objc func slide() {
        
        if (IsEnable) {return}
        
        let action1 = SKAction.run { self.IsEnable = true
            self.mainChar.xScale /= 1.1; self.mainChar.yScale /= 1.4 }
        let action2 = SKAction.animate(with: slidingFram, timePerFrame: 0.11, resize: false, restore: true)
        let action3 = SKAction.run { self.IsEnable = false
            self.mainChar.xScale *= 1.1; self.mainChar.yScale *= 1.4 }
        
        mainChar.removeAction(forKey: "Jumpping")
    
        let action = SKAction.sequence([action1,action2,action3])
        mainChar.run(SKAction.applyForce(CGVector(dx: 0, dy: -10), duration: Double(mainChar.position.y/200)))
        
        mainChar.run(action, withKey: "Slidding")
        
        run(SKAction.playSoundFileNamed("126416__cabeeno-rossley__jump", waitForCompletion: false))
       
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        // 1
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.char && contact.bodyB.categoryBitMask == PhysicsCategory.background || contact.bodyA.categoryBitMask == PhysicsCategory.background && contact.bodyB.categoryBitMask == PhysicsCategory.char) {
            
            //if (lim == 0) {lim = mainChar.position.y}
            //if (mainChar.position.y <= lim + 30 && mainChar.position.y >= lim - 30) {
                
                mainChar.removeAction(forKey: "Jumpping")
                touchTime = 0
            //}
            
            
        }
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.ostacle && contact.bodyB.categoryBitMask == PhysicsCategory.char || contact.bodyA.categoryBitMask == PhysicsCategory.char && contact.bodyB.categoryBitMask == PhysicsCategory.ostacle) {
            
            print("Happen")
            mainChar.run(SKAction.move(by: CGVector(dx: -10, dy: 0), duration: 0.5))
            
            run(SKAction.playSoundFileNamed("boulder_impact_from_catapult_or_trebuchet.mp3", waitForCompletion: false))
            
        }
        
    }
}
