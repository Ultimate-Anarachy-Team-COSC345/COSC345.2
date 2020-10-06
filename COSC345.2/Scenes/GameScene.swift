import SpriteKit
import GameplayKit
import UIKit
import AVFoundation

public class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameDifficulty:String?
    
    init(size: CGSize, difficulty: String) {
        super.init(size: size)
        gameDifficulty = difficulty
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var backgroundMusic: AVAudioPlayer?
    var background = SKSpriteNode(imageNamed:"UpdatedBackground")
    var touchLocation = CGPoint()
    var shape = CGPoint()
    var count = 0
    let label = SKLabelNode(fontNamed: "Arial-BoldMT")
    var score: Int = 0
    
    let lifeLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
    var life: String="<3 <3 <3"
    var lifeCount: Int = 3

    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    let player = SKSpriteNode(imageNamed: "player_male")
    let monster = SKSpriteNode(imageNamed: "karen")
    let food = SKSpriteNode(imageNamed: "Image")
    let hamsteak = SKSpriteNode(imageNamed: "hamsteak")
    let handsanitiser = SKSpriteNode(imageNamed: "handsanitiser")
    let toiletpaper = SKSpriteNode(imageNamed: "TP")
   // let toiletpaper = SKSpriteNode(color: UIColor.black, size: CGSize(width: 40, height: 40))
    let worker = SKSpriteNode(imageNamed: "supermarketworker")
    let mask = SKSpriteNode(imageNamed: "mask")
    let virus = SKSpriteNode(imageNamed: "Virus")
    
    let soundNode = SKNode()
    let foodPickup = SKAction.playSoundFileNamed("foodPickup.mp3", waitForCompletion: false)
    let loseLife = SKAction.playSoundFileNamed("loseLife.mp3", waitForCompletion: false)
    let gainLife = SKAction.playSoundFileNamed("gainLife.mp3", waitForCompletion: false)
    
    struct PhysicsCategory {
        static let none               :UInt32 = 0
        static let monsterCategory    :UInt32 = 0x1 << 1
        static let foodCategory       :UInt32 = 0x1 << 1
        static let hamsteakCategory   :UInt32 = 0x1 << 1
        static let sanitiserCategory  :UInt32 = 0x1 << 1
        static let toiletpaperCategory:UInt32 = 0x1 << 1
        static let workerCategory     :UInt32 = 0x1 << 1
        static let maskCategory       :UInt32 = 0x1 << 1
        static let virusCategory      :UInt32 = 0x1 << 1
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
        
        player.size = CGSize(width: 35, height: 100)
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.position = CGPoint(x: 0, y: -screenHeight/3)
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 60))
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = false
        player.zPosition = 0
        player.name = "player"
        addChild(player)
        
        label.fontColor = UIColor.black
        label.fontSize = 32
        label.text = "Score: " + String(score)
        label.position = CGPoint(x: frame.minX, y: frame.maxY/1.15)
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        addChild(label)
        
        lifeLabel.fontColor = UIColor.red
        lifeLabel.fontSize = 32
        lifeLabel.text = life
        lifeLabel.position = CGPoint(x: frame.maxX, y: frame.maxY/1.15)
        lifeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        addChild(lifeLabel)
        
        
        if gameDifficulty == "easy" {
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector:
            #selector(randomSpawningFunction), userInfo: nil, repeats: true)
        } else if gameDifficulty == "medium" {
            Timer.scheduledTimer(timeInterval: 0.3, target: self, selector:
                #selector(randomSpawningFunction), userInfo: nil, repeats: true)
        } else if gameDifficulty == "hard" {
            Timer.scheduledTimer(timeInterval: 0.2, target: self, selector:
                #selector(randomSpawningFunction), userInfo: nil, repeats: true)
        } else if gameDifficulty == "2020" {
            Timer.scheduledTimer(timeInterval: 0.05, target: self, selector:
                #selector(randomSpawningFunction), userInfo: nil, repeats: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10000)) {
            self.spawnMask(x: 0)
        }
        
        monster.physicsBody?.categoryBitMask = PhysicsCategory.monsterCategory
        food.physicsBody?.categoryBitMask = PhysicsCategory.foodCategory
        hamsteak.physicsBody?.categoryBitMask = PhysicsCategory.hamsteakCategory
        handsanitiser.physicsBody?.categoryBitMask = PhysicsCategory.sanitiserCategory
        toiletpaper.physicsBody?.categoryBitMask = PhysicsCategory.toiletpaperCategory
        worker.physicsBody?.categoryBitMask = PhysicsCategory.workerCategory
        mask.physicsBody?.categoryBitMask = PhysicsCategory.maskCategory
        virus.physicsBody?.categoryBitMask = PhysicsCategory.virusCategory
        player.physicsBody?.categoryBitMask = PhysicsCategory.playerCategory
        monster.physicsBody?.collisionBitMask = PhysicsCategory.none
        food.physicsBody?.collisionBitMask = PhysicsCategory.none
        hamsteak.physicsBody?.collisionBitMask = PhysicsCategory.none
        handsanitiser.physicsBody?.collisionBitMask = PhysicsCategory.none
        toiletpaper.physicsBody?.collisionBitMask = PhysicsCategory.none
        worker.physicsBody?.collisionBitMask = PhysicsCategory.none
        mask.physicsBody?.collisionBitMask = PhysicsCategory.none
        virus.physicsBody?.collisionBitMask = PhysicsCategory.none
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.playerCategory
        food.physicsBody?.contactTestBitMask = PhysicsCategory.playerCategory
        hamsteak.physicsBody?.contactTestBitMask = PhysicsCategory.playerCategory
        toiletpaper.physicsBody?.contactTestBitMask = PhysicsCategory.playerCategory
        worker.physicsBody?.contactTestBitMask = PhysicsCategory.playerCategory
        mask.physicsBody?.contactTestBitMask = PhysicsCategory.playerCategory
        virus.physicsBody?.contactTestBitMask = PhysicsCategory.playerCategory
        player.physicsBody?.contactTestBitMask = 2
        
        background.size = (self.frame.size)
        background.position = CGPoint(x: 0,y: 0)
        background.zPosition = -1
        addChild(background)
        addSwipeGestureRecognizers()
        
        let path = Bundle.main.path(forResource: "SUPERMARKET MUSIC", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: url)
            backgroundMusic?.numberOfLoops = -1
            backgroundMusic?.play()
        }  catch {
            // couldn't load file :(
        }
        addChild(soundNode)
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
            } else if randomInt2 == 3 {
                spawnHamsteak(x: -(screenWidth/6))
            } else if randomInt2 == 4 {
                spawnHandsanitiser(x: -(screenWidth/6))
            } else if randomInt2 == 5 {
                spawnToiletpaper(x: -(screenWidth/6))
            } else if randomInt2 == 6 {
                spawnworker(x: -(screenWidth/6))
            } else if randomInt2 == 7 {
                spawnVirus(x: -(screenWidth/6))
            }
        } else if randomInt == 2 {
            if randomInt2 == 1 {
                spawnMonster(x: -(screenWidth/3))
            } else if randomInt2 == 2 {
                spawnFood(x: -(screenWidth/3))
            } else if randomInt2 == 3 {
                spawnHamsteak(x: -(screenWidth/3))
            } else if randomInt2 == 4 {
                spawnHandsanitiser(x: -(screenWidth/3))
            } else if randomInt2 == 5 {
                spawnToiletpaper(x: -(screenWidth/3))
            } else if randomInt2 == 6 {
                spawnworker(x: -(screenWidth/3))
            } else if randomInt2 == 7 {
                spawnVirus(x: -(screenWidth/3))
            }
        } else if randomInt == 3 {
            if randomInt2 == 1 {
                spawnMonster(x: 0)
            } else if randomInt2 == 2 {
                spawnFood(x: 0)
            } else if randomInt2 == 3 {
                spawnHamsteak(x: 0)
            } else if randomInt2 == 4 {
                spawnHandsanitiser(x: 0)
            } else if randomInt2 == 5 {
                spawnToiletpaper(x: 0)
            } else if randomInt2 == 6 {
                spawnworker(x: 0)
            } else if randomInt2 == 7 {
                spawnVirus(x: 0)
            }
        } else if randomInt == 4 {
            if randomInt2 == 1 {
                spawnMonster(x: (screenWidth/3))
            } else if randomInt2 == 2 {
                spawnFood(x: (screenWidth/3))
            } else if randomInt2 == 3 {
                spawnHamsteak(x: (screenWidth/3))
            } else if randomInt2 == 4 {
                spawnHandsanitiser(x: (screenWidth/3))
            } else if randomInt2 == 5 {
                spawnToiletpaper(x: (screenWidth/3))
            } else if randomInt2 == 6 {
                spawnworker(x: (screenWidth/3))
            } else if randomInt2 == 7 {
                spawnVirus(x: (screenWidth/3))
            }
        } else if randomInt == 5 {
            if randomInt2 == 1 {
                spawnMonster(x: (screenWidth/6))
            } else if randomInt2 == 2 {
                spawnFood(x: (screenWidth/6))
            } else if randomInt2 == 3 {
                spawnHamsteak(x: (screenWidth/6))
            } else if randomInt2 == 4 {
                spawnHandsanitiser(x: (screenWidth/6))
            } else if randomInt2 == 5 {
                spawnToiletpaper(x: (screenWidth/6))
            } else if randomInt2 == 6 {
                spawnworker(x: (screenWidth/6))
            } else if randomInt2 == 7 {
                spawnVirus(x: (screenWidth/6))
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
   public func randomNumber2(range: ClosedRange<Int> = 1...7) -> Int {
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
            monsterCopy.size = CGSize(width: 150, height: 100)
            monsterCopy.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            monsterCopy.position = CGPoint(x: x, y: screenHeight/2)
            monsterCopy.zPosition = 0
            monsterCopy.physicsBody = SKPhysicsBody(circleOfRadius: monsterCopy.size.width/12)
            monsterCopy.physicsBody?.affectedByGravity = false
            monsterCopy.physicsBody?.linearDamping = 0
            monsterCopy.physicsBody?.isDynamic = true
            monsterCopy.physicsBody?.usesPreciseCollisionDetection = true
            monsterCopy.physicsBody?.velocity = CGVector(dx: 0, dy: -250)
            monsterCopy.name = "monster"
            addChild(monsterCopy)
        }
    }
    
    public func spawnHamsteak(x: CGFloat) {
        if let hamsteakCopy = hamsteak.copy() as? SKSpriteNode {
            hamsteakCopy.size = CGSize(width: 60, height: 60)
            hamsteakCopy.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            hamsteakCopy.position = CGPoint(x: x, y: screenHeight/2)
            hamsteakCopy.zPosition = 0
            hamsteakCopy.physicsBody = SKPhysicsBody(circleOfRadius: hamsteakCopy.size.width/12)
            hamsteakCopy.physicsBody?.affectedByGravity = false
            hamsteakCopy.physicsBody?.linearDamping = 0
            hamsteakCopy.physicsBody?.isDynamic = true
            hamsteakCopy.physicsBody?.usesPreciseCollisionDetection = true
            hamsteakCopy.physicsBody?.velocity = CGVector(dx: 0, dy: -250)
            hamsteakCopy.name = "hamsteak"
            addChild(hamsteakCopy)
        }
    }
    
    public func spawnHandsanitiser(x: CGFloat) {
        if let handsanitiserCopy = handsanitiser.copy() as? SKSpriteNode {
            handsanitiserCopy.size = CGSize(width: 60, height: 60)
            handsanitiserCopy.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            handsanitiserCopy.position = CGPoint(x: x, y: screenHeight/2)
            handsanitiserCopy.zPosition = 0
            handsanitiserCopy.physicsBody = SKPhysicsBody(circleOfRadius: handsanitiserCopy.size.width/12)
            handsanitiserCopy.physicsBody?.affectedByGravity = false
            handsanitiserCopy.physicsBody?.linearDamping = 0
            handsanitiserCopy.physicsBody?.isDynamic = true
            handsanitiserCopy.physicsBody?.usesPreciseCollisionDetection = true
            handsanitiserCopy.physicsBody?.velocity = CGVector(dx: 0, dy: -250)
            handsanitiserCopy.name = "handsanitiser"
            addChild(handsanitiserCopy)
        }
    }
    
    public func spawnToiletpaper(x: CGFloat) {
        if let toiletpaperCopy = toiletpaper.copy() as? SKSpriteNode {
            toiletpaperCopy.size = CGSize(width: 100, height: 100)
            toiletpaperCopy.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            toiletpaperCopy.position = CGPoint(x: x, y: screenHeight/2)
            toiletpaperCopy.zPosition = 0
            toiletpaperCopy.physicsBody = SKPhysicsBody(circleOfRadius: toiletpaperCopy.size.width/12)
            toiletpaperCopy.physicsBody?.affectedByGravity = false
            toiletpaperCopy.physicsBody?.linearDamping = 0
            toiletpaperCopy.physicsBody?.isDynamic = true
            toiletpaperCopy.physicsBody?.usesPreciseCollisionDetection = true
            toiletpaperCopy.physicsBody?.velocity = CGVector(dx: 0, dy: -250)
            toiletpaperCopy.name = "toiletpaper"
            addChild(toiletpaperCopy)
        }
    }
    
    public func spawnworker(x: CGFloat) {
        if let workerCopy = worker.copy() as? SKSpriteNode {
            workerCopy.size = CGSize(width: 90, height: 90)
            workerCopy.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            workerCopy.position = CGPoint(x: x, y: screenHeight/2)
            workerCopy.zPosition = 0
            workerCopy.physicsBody = SKPhysicsBody(circleOfRadius: workerCopy.size.width/18)
            workerCopy.physicsBody?.affectedByGravity = false
            workerCopy.physicsBody?.linearDamping = 0
            workerCopy.physicsBody?.isDynamic = true
            workerCopy.physicsBody?.usesPreciseCollisionDetection = true
            workerCopy.physicsBody?.velocity = CGVector(dx: 0, dy: -250)
            workerCopy.name = "worker"
            addChild(workerCopy)
        }
    }
    
    public func spawnMask(x: CGFloat) {
        if let maskCopy = mask.copy() as? SKSpriteNode {
            maskCopy.size = CGSize(width: 60, height: 60)
            maskCopy.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            maskCopy.position = CGPoint(x: x, y: screenHeight/2)
            maskCopy.zPosition = 0
            maskCopy.physicsBody = SKPhysicsBody(circleOfRadius: maskCopy.size.width/12)
            maskCopy.physicsBody?.affectedByGravity = false
            maskCopy.physicsBody?.linearDamping = 0
            maskCopy.physicsBody?.isDynamic = true
            maskCopy.physicsBody?.usesPreciseCollisionDetection = true
            maskCopy.physicsBody?.velocity = CGVector(dx: 0, dy: -250)
            maskCopy.name = "mask"
            addChild(maskCopy)
        }
    }
    
    public func spawnVirus(x: CGFloat) {
        if let virusCopy = virus.copy() as? SKSpriteNode {
            virusCopy.size = CGSize(width: 60, height: 60)
            virusCopy.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            virusCopy.position = CGPoint(x: x, y: screenHeight/2)
            virusCopy.zPosition = 0
            virusCopy.physicsBody = SKPhysicsBody(circleOfRadius: virusCopy.size.width/12)
            virusCopy.physicsBody?.affectedByGravity = false
            virusCopy.physicsBody?.linearDamping = 0
            virusCopy.physicsBody?.isDynamic = true
            virusCopy.physicsBody?.usesPreciseCollisionDetection = true
            virusCopy.physicsBody?.velocity = CGVector(dx: 0, dy: -250)
            virusCopy.name = "virus"
            addChild(virusCopy)
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
            foodCopy.size = CGSize(width: 40, height: 40)
            foodCopy.position = CGPoint(x: x, y: screenHeight/2)
            foodCopy.zPosition = 0
            foodCopy.physicsBody = SKPhysicsBody(circleOfRadius: foodCopy.size.width/8)
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
        if score >= 2020 {
            let reveal = SKTransition.flipVertical(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            view?.presentScene(gameOverScene, transition: reveal)
            backgroundMusic?.stop()
        }
        label.text = "Score: " + String(score)
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
            backgroundMusic?.stop()
        }
    if lifeCount == 4 {
        lifeLabel.text = "<3 <3 <3 <3"
    }
    if lifeCount == 3 {
        lifeLabel.text = "<3 <3 <3"
    }
        if lifeCount == 2 {
            lifeLabel.text = "<3 <3"
        }
        if lifeCount == 1 {
            lifeLabel.text = "<3"
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
        if contact.bodyA.node?.name == "food" {
            soundNode.run(foodPickup)
            updateScoreValue(value: 15)
            contact.bodyA.node?.removeFromParent()
        }
        if contact.bodyB.node?.name == "food" {
            soundNode.run(foodPickup)
            updateScoreValue(value: 15)
            contact.bodyB.node?.removeFromParent()
        }
        if contact.bodyA.node?.name == "monster" {
            soundNode.run(loseLife)
            updateLifeValue(value: 1)
            contact.bodyA.node?.removeFromParent()
        }
        if contact.bodyB.node?.name == "monster" {
            soundNode.run(loseLife)
            updateLifeValue(value: 1)
            contact.bodyB.node?.removeFromParent()
        }
        if contact.bodyA.node?.name == "hamsteak" {
            soundNode.run(foodPickup)
            updateScoreValue(value: 10)
            contact.bodyA.node?.removeFromParent()
        }
        if contact.bodyB.node?.name == "hamsteak" {
            soundNode.run(foodPickup)
            updateScoreValue(value: 10)
            contact.bodyB.node?.removeFromParent()
        }
        if contact.bodyA.node?.name == "handsanitiser" {
            soundNode.run(gainLife)
            if lifeCount < 4{
                lifeCount += 1
                lifeLabel.text =  life + String(" <3")
            }
            contact.bodyA.node?.removeFromParent()
        }
        if contact.bodyB.node?.name == "handsanitiser" {
            soundNode.run(gainLife)
            if lifeCount < 4{
                lifeCount += 1
                lifeLabel.text =  life + String(" <3")
            }
            contact.bodyB.node?.removeFromParent()
        }
        if contact.bodyA.node?.name == "toiletpaper" {
            soundNode.run(foodPickup)
            updateScoreValue(value: 5)
            contact.bodyA.node?.removeFromParent()
        }
        if contact.bodyB.node?.name == "toiletpaper" {
            soundNode.run(foodPickup)
            updateScoreValue(value: 5)
            contact.bodyB.node?.removeFromParent()
        }
        if contact.bodyA.node?.name == "worker" {
            soundNode.run(foodPickup)
            updateScoreValue(value: -10)
            contact.bodyA.node?.removeFromParent()
        }
        if contact.bodyB.node?.name == "worker" {
            soundNode.run(foodPickup)
            updateScoreValue(value: -10)
            contact.bodyB.node?.removeFromParent()
        }
        if contact.bodyA.node?.name == "mask" {
            soundNode.run(gainLife)
            lifeCount = 4
            lifeLabel.text = "<3 <3 <3 <3"
            contact.bodyA.node?.removeFromParent()
        }
        if contact.bodyB.node?.name == "mask" {
            soundNode.run(gainLife)
            lifeCount = 4
            lifeLabel.text = "<3 <3 <3 <3"
            contact.bodyB.node?.removeFromParent()
        }
        if contact.bodyA.node?.name == "virus" {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            view?.presentScene(gameOverScene, transition: reveal)
            backgroundMusic?.stop()
        }
        if contact.bodyB.node?.name == "virus" {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            view?.presentScene(gameOverScene, transition: reveal)
            backgroundMusic?.stop()
        }
    }
}
