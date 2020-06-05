//
//  GameScene.swift
//  COSC345.2
//
//  Authors: Makoto McLennan, Brittany Duncan, Kayla Montgomery 2020
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    enum Direction {
        case Up
        case Down
        case Left
        case Right
    }
    lazy var direction = Direction.Right
    
    // Objects for joystick
    let base = SKSpriteNode(imageNamed:"jSubstrate")
    let ball = SKSpriteNode(imageNamed:"jStick")
    // Variable that indicates if the user has moved the joystick
    var stickActive:Bool = false
    
    // Player objects
    let playerTexture = SKTexture(imageNamed: "PlaceholderPlayer")
    var player : SKSpriteNode!
    var playerIsMoving: Bool = false
    
    // Score Display objects
    var label = SKLabelNode(fontNamed: "ArialMT")
    var score: Int = 0 {
        didSet {
            label.text = "Score: \(score)"
        }
    }
    
    // Enemy objects
    let npcTexture = SKTexture(imageNamed: "blinky")
    var npc : SKSpriteNode!
    
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
    }
    
    // Called on app start
    override func sceneDidLoad() {
        // Calls method to load scene elements
        layoutScene()
    }
    
    
    func layoutScene() {
        // Sets background colour using RGB values
        backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        // Adds player from file using named image, sets position to bottom centre of screen, sets size of sprite.
        // Initialises node with player texture
        player = SKSpriteNode(texture: playerTexture)
        // Sets player size
        player.size = CGSize(width: 50, height: 50)
        // Sets player position
        player.position = CGPoint(x:frame.midX ,y:frame.minY + player.size.height)
        // Makes playertexture a physics body
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: player.size)
        // No player gravity, map is top down.
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        // Tells player node to detect all collisions and record all as contacts
        player.physicsBody?.contactTestBitMask = player.physicsBody?.collisionBitMask ?? 0
        player.name = "player"
        player.speed = 5.0
        // Adds player to the scene
        addChild(player)
        // Adds base of joystick
        base.position = CGPoint(x:frame.minX + base.size.width, y:frame.minY + base.size.height)
        //base.alpha = 0.4
        addChild(base)
        // Adds joystick
        ball.position = CGPoint(x:frame.minX + base.size.width, y:frame.minY + base.size.height)
        ball.zPosition = 1
        //ball.alpha = 0.4
        addChild(ball)
        
        label.fontColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        label.fontSize = 24
        label.text = "Score: \(score)"
        //Place the label in upper left corner of the screen
        label.position = CGPoint()
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        addChild(label)
        
        // Adds npc to scene.. Move to own method later to add multiple npc's recursively
        npc = SKSpriteNode(texture: npcTexture)
        npc.size = CGSize(width: 50, height: 50)
        npc.position = CGPoint(x: frame.midX, y: frame.midY)
        //npc.physicsBody = SKPhysicsBody(texture: npcTexture, size: npc.size)
        npc.physicsBody = SKPhysicsBody(circleOfRadius: npc.size.width/2)
        npc.physicsBody?.affectedByGravity = false
        npc.physicsBody?.isDynamic = false
        npc.physicsBody?.contactTestBitMask = npc.physicsBody?.collisionBitMask ?? 0
        npc.name = "blinky"
        npc.speed = 3.0
        addChild(npc)
        
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
                playerIsMoving = true
                let v = CGVector(dx: location.x - base.position.x, dy:location.y - base.position.y)
                // Converts vector "v" to an angle in radians
                let angle = atan2(v.dy, v.dx)
                let length:CGFloat = base.frame.size.height / 2
                let xDist:CGFloat = sin(angle-CGFloat(0.5 * .pi)) * length
                let yDist:CGFloat = cos(angle-CGFloat(0.5 * .pi)) * length
                
                // Lets ball follow touches within frame of joystick
                if (base.frame.contains(location)) {
                    ball.position = location
                }else {
                    // Lets ball track touches from outside the joystick without letting ball move away from joystick pad
                    ball.position = CGPoint(x:base.position.x - xDist, y:base.position.y + yDist)
                }
                // player rotation matches position of joystick
                switch (angle) {
                    // Facing Up
                case (0.25 * .pi)...(0.75 * .pi):
                    player.zRotation = 0.0
                    direction = .Up
                    break
                    // Facing Down
                case (-0.75 * .pi)...(-0.25 * .pi):
                    player.zRotation = .pi
                    direction = .Down
                    break
                    // Facing Right
                case (-0.25 * .pi)...(0.25 * .pi):
                    player.zRotation = .pi/2
                    direction = .Right
                    break
                    // Facing Left
                case (-1.25 * .pi)...(1.25 * .pi):
                    player.zRotation = .pi / -2
                    direction = .Left
                    break
                default:
                    return
                }
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
            // Stops player movement when screen is no longer being touched
            playerIsMoving = false
        }
    }
    
    func collision(between player: SKNode, object: SKNode) {
        if object.name == "blinky" {
            player.removeFromParent()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "player" {
            collision(between: contact.bodyB.node!, object: contact.bodyA.node!)
        } else if contact.bodyB.node?.name == "player" {
            collision(between: contact.bodyA.node!, object: contact.bodyB.node!)
        }
        if contact.bodyA.node?.name == "blinky" {
            collision(between: contact.bodyB.node!, object: contact.bodyA.node!)
        } else if contact.bodyB.node?.name == "blinky" {
            collision(between: contact.bodyA.node!, object: contact.bodyB.node!)
        }
    }
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        if playerIsMoving {
            switch (direction) {
            case .Up:
                let move = SKAction.moveBy(x: 0.0, y: player.speed, duration: 0.1)
                player.run(move)
            case .Down:
                let move = SKAction.moveBy(x: 0.0, y: -player.speed, duration: 0.1)
                player.run(move)
            case .Left:
                let move = SKAction.moveBy(x: -player.speed, y: 0.0, duration: 0.1)
                player.run(move)
            case .Right:
                let move = SKAction.moveBy(x: player.speed, y: 0.0, duration: 0.1)
                player.run(move)
                
            }
        }
    }
    
}











