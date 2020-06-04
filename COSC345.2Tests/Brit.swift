//
//  Brit.swift
//  COSC345.2
//
//  Created by Brittany Duncan on 4/06/20.
//  Copyright © 2020 makayla montgomery. All rights reserved.
//


import SpriteKit

class Brit: SKScene {
    
    var label = SKLabelNode(fontNamed: "ArialMT")
    
    var score: Int = 0 {
        didSet {
            label.text = "Score: \(score)"
        }
    }
    
    override func didMove(view: SKView) {
        
        
        label.fontSize = 24
        label.text = "Score: \(score)"
        
        //Place the label in upper left corner of the screen
        label.position = CGPoint(x: self.frame.width / 2 + 60, y: self.frame.height / 2 + 335)
        
        //Add this
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        addChild(label)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        score+=5
    }
}
