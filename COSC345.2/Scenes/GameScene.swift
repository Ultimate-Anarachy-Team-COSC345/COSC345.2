//
//  GameScene.swift
//  COSC345.2
//
//  Created by makayla montgomery on 8/05/20.
//  Copyright © 2020 makayla montgomery. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var playerSprite: SKSpriteNode!
    override func sceneDidLoad() {
        layoutScene()
    }
    func layoutScene() {
        backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        
        playerSprite = SKSpriteNode(imageNamed:"PlaceholderPlayer")
        playerSprite.size = CGSize()
    }
}

