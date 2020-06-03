//
//  GameScene.swift
//  COSC345.2
//
//  Created by makayla montgomery on 8/05/20.
//  Copyright © 2020 makayla montgomery. All rights reserved.
//

import SpriteKit
import GameController

class GameScene: SKScene {
    let base = SKSpriteNode(imageNamed:"jSubstrate")
    let ball = SKSpriteNode(imageNamed:"jStick")
    var playerSprite : SKSpriteNode!
    
    override func sceneDidLoad() {
        // Calls method to load scene elements
        layoutScene()
    }
    func layoutScene() {
        // Sets background colour using RGB values
        backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        // Adds playerSprite from file using named image, sets position to bottom centre of screen, sets size of sprite.
        playerSprite = SKSpriteNode(imageNamed:"PlaceholderPlayer")
        playerSprite.size = CGSize(width: 50, height: 50)
        playerSprite.position = CGPoint(x:frame.midX ,y:frame.minY + playerSprite.size.height)
        addChild(playerSprite)
        // Adds base of joystick
        base.position = CGPoint(x:frame.minX + base.size.width, y:frame.minY + base.size.height)
        //base.alpha = 0.4
        addChild(base)
        // Adds joystick
        ball.position = CGPoint(x:frame.minX + base.size.width, y:frame.minY + base.size.height)
        ball.zPosition = 1
        //ball.alpha = 0.4
        addChild(ball)
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Touches method for joystick tracking
        for touch in (touches as! Set<UITouch>) {
            let location = touch.location(in: self)
            let v = CGVector(dx: location.x - base.position.x, dy:location.y - base.position.y)
            let angle = atan2(v.dy, v.dx)
            
            let deg = angle * CGFloat(180/Double.pi)
            print(deg + 180)
            
            let length:CGFloat = base.frame.size.height / 2
            
            let xDist:CGFloat = sin(angle - 1.57079633) * length
            let yDist:CGFloat = cos(angle - 1.57079633) * length
            
            // Lets ball follow touches within frame of joystick
            if (base.frame.contains(location)) {
                ball.position = location
            }else {
                // Lets ball track touches from outside the joystick without letting ball move away from joystick pad
                ball.position = CGPoint(x:base.position.x - xDist, y:base.position.y + yDist)
                
            }
        }
    }
}





