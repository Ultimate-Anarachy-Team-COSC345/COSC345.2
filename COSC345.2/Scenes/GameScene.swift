import SpriteKit
import GameplayKit
import UIKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
    override init(size: CGSize) {
        super.init(size: size)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var background = SKSpriteNode(imageNamed:"BackgroundCovid")
    var touchLocation = CGPoint()
    var shape = CGPoint()
    var count = 0
    let label = SKLabelNode(fontNamed: "ArialMT")
    var score: Int=0
    
    let lifelabel = SKLabelNode(fontNamed: "ArialMT")
    var life: String="<3 <3 <3"
    var lifeCount: Int=3
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    let player = SKSpriteNode(imageNamed: "Player")
    let monster = SKSpriteNode(imageNamed: "Karen Sprite2.1 transparent")
    let food = SKSpriteNode(imageNamed: "Image")
    
    struct PhysicsCategory {
        static let none               :UInt32 = 0
        static let monsterCategory    :UInt32 = 0x1 << 1
        static let foodCategory       :UInt32 = 0x1 << 1
        static let playerCategory     :UInt32 = 0x1 << 0
    }
    
    /**
 Called immediately after a scene is presented by a view. This method to creates the scene’s contents.
     A contact is used when you need to know that two bodies are touching each other
     A collision is used to prevent two objects from interpenetrating each other
     An SKPhysicsBody object defines the shape and simulation parameters for a physics body in the system.
 - Parameters:
    - view: The view that is presenting the scene.
 */
    public override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        backgroundColor = UIColor.black
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.position = CGPoint(x: 0, y: -screenHeight/3)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = false
        player.zPosition = 0
        player.name = "player"
        addChild(player)
        
        label.fontColor = UIColor.white
        label.fontSize = 24
        label.text = "Score: \(score)"
        label.position = CGPoint(x: frame.minX, y: frame.minY)
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        addChild(label)
        
        lifelabel.fontColor = UIColor.red
        lifelabel.fontSize = 24
        lifelabel.text = life
        lifelabel.position = CGPoint(x: frame.maxX, y: frame.minY)
        lifelabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        addChild(lifelabel)
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector:
            #selector(randomSpawningFunction), userInfo: nil, repeats: true)
        
        monster.physicsBody?.categoryBitMask = PhysicsCategory.monsterCategory
        food.physicsBody?.categoryBitMask = PhysicsCategory.foodCategory
        player.physicsBody?.categoryBitMask = PhysicsCategory.playerCategory
        monster.physicsBody?.collisionBitMask = PhysicsCategory.none
        food.physicsBody?.collisionBitMask = PhysicsCategory.none
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.playerCategory
        food.physicsBody?.contactTestBitMask = PhysicsCategory.playerCategory
        player.physicsBody?.contactTestBitMask = 2
        
        background.position = CGPoint(x: 0,y: 0)
        background.zPosition = -1
        addChild(background)
        addSwipeGestureRecognizers()
    }
    
    /**
     randomSpawningFunction a random number is generated every 1/2 a second in which a monster or food is spawned
     - returns: a randomly spawned monster or food
     */
    @objc public func randomSpawningFunction() {
        let randomInt = randomNumber()
        let randomInt2 = randomNumber2()
        if randomInt == 1 {
            if randomInt2 == 1 {
                spawnMonster(x: -(screenWidth/6))
            } else if randomInt2 == 2 {
                spawnFood(x: -(screenWidth/6))
            }
        } else if randomInt == 2 {
            if randomInt2 == 1 {
                spawnMonster(x: -(screenWidth/3))
            } else if randomInt2 == 2 {
                spawnFood(x: -(screenWidth/3))
            }
        } else if randomInt == 3 {
            if randomInt2 == 1 {
                spawnMonster(x: 0)
            } else if randomInt2 == 2 {
                spawnFood(x: 0)
            }
        } else if randomInt == 4 {
            if randomInt2 == 1 {
                spawnMonster(x: (screenWidth/3))
            } else if randomInt2 == 2 {
                spawnFood(x: (screenWidth/3))
            }
        } else if randomInt == 5 {
            if randomInt2 == 1 {
                spawnMonster(x: (screenWidth/6))
            } else if randomInt2 == 2 {
                spawnFood(x: (screenWidth/6))
            }
        }
    }
    
    /**
     randomNumber generator to generate an int between 1 to 5 inclusive
     - Parameters:
        - range: int between 1 to 5 inclusive
     - returns: a randomly generated int between 1 and 5 inclusive
 */
   public func randomNumber(range: ClosedRange<Int> = 1...5) -> Int {
        let min = range.lowerBound
        let max = range.upperBound
        return Int(arc4random_uniform(UInt32(1 + max - min))) + min
    }
    
    /**
     randomNumber2 generator to generate an int between 1 to 2 inclusive
     - Parameters:
        - range: int between 1 to 2 inclusive
     - returns: a randomly generated int between 1 and 2 inclusive
     */
   public func randomNumber2(range: ClosedRange<Int> = 1...2) -> Int {
        let min = range.lowerBound
        let max = range.upperBound
        return Int(arc4random_uniform(UInt32(1 + max - min))) + min
    }
    
    /**
     spawnMonster creates a copy of monster so that many of the same monster object can be spawned
     many times and act as thier own individual entities
     - Parameters:
        - x: a GCFloat to decide what lane the spawned monster will fall down
     - Returns: a spawned monster just on the top vertical edge of the screen based on x
 */
   public func spawnMonster(x: CGFloat) {
        if let monsterCopy = monster.copy() as? SKSpriteNode {
            monsterCopy.size = CGSize(width: 50, height: 50)
            monsterCopy.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            monsterCopy.position = CGPoint(x: x, y: screenHeight/2)
            monsterCopy.zPosition = 0
            monsterCopy.physicsBody = SKPhysicsBody(circleOfRadius: monster.size.width/2)
            monsterCopy.physicsBody?.affectedByGravity = false
            monsterCopy.physicsBody?.linearDamping = 0
            monsterCopy.physicsBody?.isDynamic = true
            monsterCopy.physicsBody?.usesPreciseCollisionDetection = true
            monsterCopy.physicsBody?.velocity = CGVector(dx: 0, dy: -250)
            monsterCopy.name = "monster"
            addChild(monsterCopy)
        }
    }
    
    /**
     spawnFood creates a copy of food so that many of the same food object can be spawned
     many times and act as thier own individual entities
     - Parameters:
        - x: a GCFloat to decide what lane the spawned food will fall down
     - Returns: a spawned food just on the top vertical edge of the screen based on x
     */
   public func spawnFood(x: CGFloat) {
        if let foodCopy = food.copy() as? SKSpriteNode {
            foodCopy.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            foodCopy.size = CGSize(width: 50, height: 40)
            foodCopy.position = CGPoint(x: x, y: screenHeight/2)
            foodCopy.zPosition = 0
            foodCopy.physicsBody = SKPhysicsBody(circleOfRadius: food.size.width/8)
            foodCopy.physicsBody?.affectedByGravity = false
            foodCopy.physicsBody?.linearDamping = 0
            foodCopy.physicsBody?.isDynamic = true
            foodCopy.physicsBody?.velocity = CGVector(dx: 0, dy: -250)
            foodCopy.name = "food"
            addChild(foodCopy)
        }
    }
    
    /**
    Adding the swipe gestures left and right to the scene
 - Returns: the array of left and right swipe gestures
 */
    public func addSwipeGestureRecognizers() {
        let gestureDirections: [UISwipeGestureRecognizerDirection] = [.right, .left]
        for gestureDirection in gestureDirections {
            let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            gestureRecognizer.direction = gestureDirection
            self.view?.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    /**
 Handles the swipe gestures and decides where the player moves
 - Parameters:
    - gesture: left or right gesture based on users actions
 */
    @objc public func handleSwipe(gesture: UIGestureRecognizer) {
        if let gesture = gesture as? UISwipeGestureRecognizer {
            switch gesture.direction {
            case .right:
                if count < 3 {
                    count += 1
                    if count == -1 {
                        player.position = CGPoint(x: -(screenWidth/6), y: -screenHeight/3)
                    }
                    if count == 0 {
                        player.position = CGPoint(x: 0, y: -screenHeight/3)
                    }
                    if count == 1 {
                        player.position = CGPoint(x: screenWidth/6, y: -screenHeight/3)
                    }
                    if count == 2 {
                        player.position = CGPoint(x: (screenWidth/3), y: -screenHeight/3)
                    }
                }
            case .left:
                if count > -3 {
                    count -= 1
                    if count == 1 {
                        player.position = CGPoint(x: screenWidth/6, y: -screenHeight/3)
                    }
                    if count == 0 {
                        player.position = CGPoint(x: 0, y: -screenHeight/3)
                    }
                    if count == -1 {
                        player.position = CGPoint(x: -screenWidth/6, y: -screenHeight/3)
                    }
                    if count == -2 {
                        player.position = CGPoint(x: -screenWidth/3, y: -screenHeight/3)
                    }
                }
            default:
                print("no such gesture")
            }
        }
    }
    
    /**
 Updates the score value. To win the game at the moment you need to have a score of 50
 - Parameters:
    - value: int which adds 10 to the score
 - returns: the updated label score
 */
   public func updateScoreValue(value: Int) {
        score += value
        if score == 250 {
            let reveal = SKTransition.flipVertical(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            view?.presentScene(gameOverScene, transition: reveal)
        }
        label.text = "Score: \(score)"
    }
    
    /**
 Updates the life value, in a game you get three lives
 - Parameters:
     - value: int which decreses the life count by 1
 - returns: the updated hearts on the bottom of the screen
 */
   public func updateLifeValue(value: Int) {
        lifeCount -= value
        if lifeCount == 0 {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            view?.presentScene(gameOverScene, transition: reveal)
        }
        if lifeCount == 2 {
            lifelabel.text = "<3 <3"
        }
        if lifeCount == 1 {
            lifelabel.text = "<3"
        }
    }
    /**
 Removes every sprite that comes in contact with the player
 - Parameters:
    - nodeA: the node that collides with the player node
    - nodeB: the player that collides with all other nodes
 */
   public func projectileDidCollideWithPlayer(nodeA: SKSpriteNode, nodeB: SKSpriteNode) {
        nodeA.removeFromParent()
    }

    /**
 Is called when a collision happens between player and food or monster
 - Parameters:
     - contact: the collison that occurs
 - returns: the node which collided with the player is removed
 */
    public func didBegin(_ contact: SKPhysicsContact) {
        // 1
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if (firstBody.categoryBitMask & PhysicsCategory.monsterCategory) != 0 && (secondBody.categoryBitMask & PhysicsCategory.playerCategory) != 0{
            projectileDidCollideWithPlayer(nodeA: firstBody.node as! SKSpriteNode, nodeB: secondBody.node as! SKSpriteNode)
            if firstBody.node?.name == "food" {
                updateScoreValue(value: 10)
            } else if firstBody.node?.name == "monster" {
                updateLifeValue(value: 1)
            }
        } else if (firstBody.categoryBitMask & PhysicsCategory.foodCategory) != 0 && (secondBody.categoryBitMask & PhysicsCategory.playerCategory) != 0{
            projectileDidCollideWithPlayer(nodeA: firstBody.node as! SKSpriteNode, nodeB: secondBody.node as! SKSpriteNode)
            if firstBody.node?.name == "food" {
                updateScoreValue(value: 10)
            } else if firstBody.node?.name == "monster" {
                updateLifeValue(value: 1)
            }
        }
    }
}
