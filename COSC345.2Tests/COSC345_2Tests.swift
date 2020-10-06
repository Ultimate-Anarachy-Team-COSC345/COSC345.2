//
//  COSC345_2Tests.swift
//  COSC345.2Tests
//
//  Created by makayla montgomery on 8/05/20.
//  Copyright © 2020 makayla montgomery. All rights reserved.
//

import XCTest
import SpriteKit
import UIKit
@testable import COSC345_2

public class COSC345_2Tests: XCTestCase {
    public override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    public override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMenuSceneNotNull() {
        //let gvc = GameViewController()
        let testView = SKView()
        let menuscene = MenuScene(size: testView.bounds.size)
        XCTAssertNotNil(menuscene)
    }
    
    func testGameOverSceneNotNull() {
        let testView = SKView()
        let gos = GameOverScene(size: testView.bounds.size, won: true)
        XCTAssertNotNil(gos)
    }
    
    func testGameSceneDidLoad() {
        let testView = SKView()
        let gamescene = GameScene(size: testView.bounds.size, difficulty: "easy")
        XCTAssertNotNil(gamescene)
    }
    
    func testDifficultyScene() {
        let testView = SKView()
        let diffScene = DifficultyScene(size: testView.bounds.size)
        XCTAssertNotNil(diffScene)
    }
    
    func testRandomNumberGenerator() {
        let testView = SKView()
        let gamescene = GameScene(size: testView.bounds.size, difficulty: "easy")
        let int: Int=gamescene.randomNumber(range: 1...5)
        XCTAssertTrue(int > 0 && int < 6)
    }
    
    func testRandomNumberGenerator2() {
        let testView = SKView()
        let gamescene = GameScene(size: testView.bounds.size, difficulty: "easy")
        let int: Int=gamescene.randomNumber2(range: 1...2)
        XCTAssertTrue(int > 0 && int < 3)
    }
    
    func testSpawnMonster() {
        let testView = SKView()
        let gamescene = GameScene(size: testView.bounds.size, difficulty: "easy")
        let monsterCopy = gamescene.spawnMonster(x: 0)
        XCTAssertNotNil(monsterCopy)
    }
    
    func testSpawnFood() {
        let testView = SKView()
        let gamescene = GameScene(size: testView.bounds.size, difficulty: "easy")
        let foodCopy = gamescene.spawnFood(x: 0)
        XCTAssertNotNil(foodCopy)
    }
    
    func testSpawnHamsteak() {
        let testView = SKView()
        let gamescene = GameScene(size: testView.bounds.size, difficulty: "medium")
        let hamsteakCopy = gamescene.spawnHamsteak(x: 0)
        XCTAssertNotNil(hamsteakCopy)
    }
    
    func testSpawnHandSanitiser() {
        let testView = SKView()
        let gamescene = GameScene(size: testView.bounds.size, difficulty: "hard")
        let handsanitiserCopy = gamescene.spawnHandsanitiser(x: 0)
        XCTAssertNotNil(handsanitiserCopy)
    }
    
    func testSpawnTP() {
        let testView = SKView()
        let gamescene = GameScene(size: testView.bounds.size, difficulty: "hard")
        let toiletPaperCopy = gamescene.spawnToiletpaper(x: 0)
        XCTAssertNotNil(toiletPaperCopy)
    }
    
    func testSpawnWorker() {
        let testView = SKView()
        let gamescene = GameScene(size: testView.bounds.size, difficulty: "hard")
        let workerCopy = gamescene.spawnworker(x: 0)
        XCTAssertNotNil(workerCopy)
    }
    
    func testSpawnMask() {
        let testView = SKView()
        let gamescene = GameScene(size: testView.bounds.size, difficulty: "hard")
        let maskCopy = gamescene.spawnMask(x: 0)
        XCTAssertNotNil(maskCopy)
    }
    
    func testSpawnVirus() {
        let testView = SKView()
        let gamescene = GameScene(size: testView.bounds.size, difficulty: "hard")
        let virusCopy = gamescene.spawnVirus(x: 0)
        XCTAssertNotNil(virusCopy)
    }
    
    func testupdateScoreValue() {
        let testView = SKView()
        let gamescene = GameScene(size: testView.bounds.size, difficulty: "easy")
        let score: Int=10
        gamescene.updateScoreValue(value: 10)
        XCTAssertEqual(score, gamescene.score)
        gamescene.score = 40
        gamescene.updateScoreValue(value: 10)
        let score2: Int=50
        XCTAssertEqual(score2, gamescene.score)
    }
    
    func testUpdateLifeValue() {
        let testView = SKView()
        let gamescene = GameScene(size: testView.bounds.size, difficulty: "easy")
        let lifeCount: Int=2
        gamescene.updateLifeValue(value: 1)
        XCTAssertEqual(lifeCount, gamescene.lifeCount)
        gamescene.lifeCount = 1
        gamescene.updateLifeValue(value: 1)
        let lifeCount2: Int=0
        XCTAssertEqual(lifeCount2, gamescene.lifeCount)
    }

    func testScreenDimensions() {
        let testView = SKView()
        let gamescene = GameScene(size: testView.bounds.size, difficulty: "easy")
        let width: CGFloat=gamescene.screenWidth
        let height: CGFloat=gamescene.screenHeight
        XCTAssertTrue(width > 0 && height > 0)
    }
    
    func testRandomSpawningFunciton() {
        let testView = SKView()
        let gamescene = GameScene(size: testView.bounds.size, difficulty: "easy")
        gamescene.randomSpawningFunction()
        XCTAssertTrue(gamescene.randomNumber() > 0 && gamescene.randomNumber2() > 0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
        
    }
    
}
