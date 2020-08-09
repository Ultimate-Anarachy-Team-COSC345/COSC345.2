//
//  GameOverScene.swift
//  swipeGestures
//
//  Created by Brittany Duncan on 7/08/20.
//


import Foundation
import SpriteKit

class GameOverScene: SKScene {
    init(size: CGSize, won:Bool) {
        super.init(size: size)
        
        // 1
        backgroundColor = SKColor.black
        
        // 2
        let message = won ? "You Murdered the Elderly!" : "Haha you suck :["
        
        // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 20
        label.fontColor = SKColor.white
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        // 4
        run(SKAction.sequence([
            SKAction.wait(forDuration: 5.0),
            SKAction.run() { [weak self] in
                // 5
                guard let `self` = self else { return }
                let reveal = SKTransition.flipVertical(withDuration: 0.5)
                let scene = MenuScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
    }
    
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
