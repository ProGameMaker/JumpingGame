//
//  Title.swift
//  JumpingGame
//
//  Created by Nguyễn Trí on 10/4/18.
//  Copyright © 2018 Nguyễn Trí. All rights reserved.
//

import SpriteKit

class Menu: SKScene {
    
    let restartButton = SKLabelNode(fontNamed: "Copperplate")
    let guideButton = SKLabelNode(fontNamed: "Copperplate")
    let returnButton = SKLabelNode(fontNamed: "Copperplate")
    let guide = SKLabelNode(fontNamed: "Copperplate")
    let title = SKLabelNode(fontNamed: "Copperplate")
    let effectsNode = SKEffectNode()
    
    func blurScreen() {
        
        let filter = CIFilter(name: "CIGaussianBlur")
        let blurAmount = 10.0
        filter!.setValue(blurAmount, forKey: kCIInputRadiusKey)
        
        effectsNode.filter = filter
        effectsNode.position = self.view!.center
        effectsNode.blendMode = .alpha
        
        // Add the effects node to the scene
        self.addChild(effectsNode)
    }
    
    override func didMove(to view: SKView) {
        
        let backgroundMusic = SKAudioNode(fileNamed: "Fun Adventure.mp3")
        backgroundMusic.autoplayLooped = true
        //backgroundMusic.run(SKAction.changeVolume(by: Float(0.1), duration: 0))
        addChild(backgroundMusic)
        
        let background = SKSpriteNode(imageNamed: "Mystic_Ruins_Cutscene_Background")
        background.size = CGSize(width: (scene?.size.width)!, height: (scene?.size.height)!)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.zPosition = -4
        addChild(background)
        
        title.position = CGPoint(x: (scene?.size.width)!/2, y: (scene?.size.height)!/1.5)
        title.text = "Jumping Game"
        title.horizontalAlignmentMode = .center
        title.fontSize = 45
        title.fontColor = SKColor.green
        title.zPosition = 4
        
        addChild(title)
        
        returnButton.position = CGPoint(x: (scene?.size.width)!/2, y: (scene?.size.height)!/10)
        returnButton.text = "Return"
        returnButton.horizontalAlignmentMode = .center
        returnButton.fontSize = 40
        returnButton.fontColor = SKColor.white
        returnButton.zPosition = 4
        returnButton.isHidden = true
        
        addChild(returnButton)
        
        guide.position = CGPoint(x: (scene?.size.width)!/2, y: (scene?.size.height)!/2)
        guide.numberOfLines = 3
        guide.text = "Tap to jum \nDouble tap to double jump \nSlide down to slide"
        guide.horizontalAlignmentMode = .center
        guide.fontSize = 25
        guide.fontColor = SKColor.white
        guide.zPosition = 4
        guide.isHidden = true
        
        addChild(guide)
    
        guideButton.position = CGPoint(x: (scene?.size.width)!/2, y: (scene?.size.height)!/2 - 100)
        guideButton.text = "How to play"
        guideButton.horizontalAlignmentMode = .center
        guideButton.fontSize = 40
        guideButton.fontColor = SKColor.white
        guideButton.zPosition = 4
        
        addChild(guideButton)
        
        
        
        restartButton.position = CGPoint(x: (scene?.size.width)!/2, y: (scene?.size.height)!/2)
        restartButton.text = "Start"
        restartButton.horizontalAlignmentMode = .center
        restartButton.fontSize = 40
        restartButton.fontColor = SKColor.white
        restartButton.zPosition = 4
    
        addChild(restartButton)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            //self.view?.isPaused = false
    
            if restartButton.contains(touch.location(in: self)) && !restartButton.isHidden {
                
                let reveal = SKTransition.crossFade(withDuration: 0.5)
                let newscene = GameScene(size: size)
                self.view?.presentScene(newscene, transition:reveal)
            }
            
            if guideButton.contains(touch.location(in: self)) && !guideButton.isHidden {
                
                blurScreen()
                guideButton.isHidden = true
                restartButton.isHidden = true
                guide.isHidden = false
                returnButton.isHidden = false
            }
            
            if returnButton.contains(touch.location(in: self)) {
                
                effectsNode.removeFromParent()
                returnButton.isHidden = true
                restartButton.isHidden = false
                guideButton.isHidden = false
                guide.isHidden = true
                
            }
            
        }
        
        
        
    }
    
    
    
    
}
