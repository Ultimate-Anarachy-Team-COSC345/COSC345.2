//
//  DifficultyScene.swift
//  COSC345.2
//
//  Created by Brittany Duncan on 12/09/20.
//  Copyright © 2020 makayla montgomery. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class DifficultyScene: SKScene {
    let easyButton = SKLabelNode()
    let mediumButton = SKLabelNode()
    let hardButton = SKLabelNode()
    let twentyButton = SKLabelNode()
    var backgroundMusic: AVAudioPlayer?
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
        easyButton.fontColor = SKColor.white
        easyButton.text = "easy"
        
        mediumButton.fontColor = SKColor.white
        mediumButton.text = "medium"
        
        hardButton.fontColor = SKColor.white
        hardButton.text = "hard"
        
        twentyButton.fontColor = SKColor.white
        twentyButton.text = "2020"
        
        easyButton.position = CGPoint(x: size.width/2, y: size.height/2+150)
        mediumButton.position = CGPoint(x: size.width/2, y: size.height/2+50)
        hardButton.position = CGPoint(x: size.width/2, y: size.height/2-50 )
        twentyButton.position = CGPoint(x: size.width/2, y: size.height/2-150)
        
        addChild(easyButton)
        addChild(mediumButton)
        addChild(hardButton)
        addChild(twentyButton)
    
        let path = Bundle.main.path(forResource: "SUPERMARKET MUSIC Royalty-free - Bit Orchestra", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: url)
            backgroundMusic?.play()
        }  catch {
            // couldn't load file :(
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if easyButton.contains(touchLocation) {
            let reveal = SKTransition.doorsOpenVertical(withDuration: 0.5)
            let gameScene = GameScene(size: self.size, difficulty: easyButton.text!)
            self.view?.presentScene(gameScene, transition: reveal)
        }
        
        if mediumButton.contains(touchLocation) {
            let reveal = SKTransition.doorsOpenVertical(withDuration: 0.5)
            let gameScene = GameScene(size: self.size, difficulty: mediumButton.text!)
            self.view?.presentScene(gameScene, transition: reveal)
        }
        
        if hardButton.contains(touchLocation){
            let reveal = SKTransition.doorsOpenVertical(withDuration: 0.5)
            let gameScene = GameScene(size: self.size, difficulty: hardButton.text!)
            self.view?.presentScene(gameScene, transition: reveal)
        }
        
        if twentyButton.contains(touchLocation){
            let reveal = SKTransition.doorsOpenVertical(withDuration: 0.5)
            let gameScene = GameScene(size: self.size, difficulty: twentyButton.text!)
            self.view?.presentScene(gameScene, transition: reveal)
        }
    }
}
