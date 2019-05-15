//
//  GameOverScene.swift
//  JumpingGame
//
//  Created by Nguyễn Trí on 10/3/18.
//  Copyright © 2018 Nguyễn Trí. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    let restartButton = SKLabelNode(fontNamed: "Copperplate")
    let menuButton = SKLabelNode(fontNamed: "Copperplate")
    
    init(size: CGSize, score: Int) {
        super.init(size: size)
        
        //let backgroundMusic = SKAudioNode(fileNamed: "Rues-whistle-piano.mp3")
        //backgroundMusic.autoplayLooped = true
        //backgroundMusic.run(SKAction.changeVolume(by: Float(0.1), duration: 0))
        //addChild(backgroundMusic)
        
        let background = SKSpriteNode(imageNamed: "Mystic_Ruins_Cutscene_Background")
        background.size = CGSize(width: (scene?.size.width)!, height: (scene?.size.height)!)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.zPosition = -4
        addChild(background)
        
        // restartButton
        restartButton.position = CGPoint(x: (scene?.size.width)!/3, y: (scene?.size.height)!/10)
        restartButton.text = "Restart"
        restartButton.horizontalAlignmentMode = .center
        restartButton.fontSize = 30
        restartButton.fontColor = SKColor.white
        restartButton.zPosition = 4
        
        addChild(restartButton)
        
        menuButton.position = CGPoint(x: (scene?.size.width)!/3 * 2, y: (scene?.size.height)!/10)
        menuButton.text = "Menu"
        menuButton.horizontalAlignmentMode = .center
        menuButton.fontSize = 30
        menuButton.fontColor = SKColor.white
        menuButton.zPosition = 4
        
        addChild(menuButton)
        
        // save highscore
        var savedScore: Int = 0
        if (UserDefaults.standard.object(forKey: "HighestScore") == nil) { savedScore = score }
        else {  savedScore = UserDefaults.standard.object(forKey: "HighestScore") as! Int
                if (score > savedScore) { savedScore = score} }
        
        UserDefaults.standard.set(savedScore, forKey:"HighestScore")
        UserDefaults.standard.synchronize()
        
        let message = " Game Over\n\n Score: \(score) \n Best score: \(savedScore) "
        
        let label = SKLabelNode(fontNamed: "Copperplate")
        label.numberOfLines = 4
        label.text = message
        label.horizontalAlignmentMode = .center
        label.fontSize = 40
        label.fontColor = SKColor.white
        label.position = CGPoint(x: size.width/2, y: size.height/3)
        addChild(label)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            if restartButton.contains(touch.location(in: self)) {
                
                let reveal = SKTransition.crossFade(withDuration: 0.5)
                let newscene = GameScene(size: size)
                self.view?.presentScene(newscene, transition:reveal)
            }
            
            if menuButton.contains(touch.location(in: self)) {
                
                let reveal = SKTransition.crossFade(withDuration: 0.5)
                let newscene = Menu(size: size)
                self.view?.presentScene(newscene, transition:reveal)
            }
            
            
            
        }
    }
    
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

