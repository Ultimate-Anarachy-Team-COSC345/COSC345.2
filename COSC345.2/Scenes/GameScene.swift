//
//  GameScene.swift
//  COSC345.2
//
//  Authors: Makoto McLennan, Brittany Duncan, Kayla Montgomery 2020
//

import SpriteKit
import GameController

class GameScene: SKScene {
    let base = SKSpriteNode(imageNamed:"jSubstrate")
    let ball = SKSpriteNode(imageNamed:"jStick")
    var playerSprite : SKSpriteNode!
    // Variable that indicates if the user has moved the joystick
    var stickActive:Bool = false
    
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Called when touches begin
        for touch in (touches){
            let location = touch.location(in: self)
            if (base.frame.contains(location)) {
                stickActive = true
            } else {
                stickActive = false
            }
        }
    }
    
    // Function containing methods for touches
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Touches method for joystick tracking
        // For loop checks for screen touches.
        for touch in (touches) {
            let location = touch.location(in: self)
            // Checks if user is touching joystick before activating joystick
            if (stickActive) {
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
                // PlayerSprite rotation matches position of joystick
                playerSprite.zRotation = angle - 1.57079633
                // Player moves by fraction of vector "v" from joystick
                let playerMove:SKAction = SKAction.move(by: v, duration:0.1)
                playerSprite.run(playerMove)
                
            } // Ends stickactive test
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Moves joystick ball to base position once screen is no longer touched
        if (stickActive) {
            // elasticJoy SKAction causes the joystick ball to return to base position
            let elasticJoy:SKAction = SKAction.move(to:base.position, duration:0.2)
            elasticJoy.timingMode = .easeOut
            
            ball.run(elasticJoy)
            
        }
        
    }
}





