//
//  COSC345_2Tests.swift
//  COSC345.2Tests
//
//  Created by makayla montgomery on 8/05/20.
//  Copyright © 2020 makayla montgomery. All rights reserved.
//

import XCTest
import SpriteKit
@testable import COSC345_2

class COSC345_2Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMenuSceneNotNull() {
        //let gvc = GameViewController()
        let testView = SKView()
        let ms = MenuScene(size: testView.bounds.size)
        XCTAssertNotNil(ms)
    }
    
    func testGameOverSceneNotNull() {
        let testView = SKView()
        let gos = GameOverScene(size: testView.bounds.size, won: true)
        XCTAssertNotNil(gos)
    }
    
    func testGameSceneDidLoad() {
        let testView = SKView()
        let gs = GameScene(size: testView.bounds.size)
        XCTAssertNotNil(gs)
    }
    
    func testRandomNumberGenerator() {
        let testView = SKView()
        let gs = GameScene(size: testView.bounds.size)
        let int:Int = gs.randomNumber(range: 1...5)
        XCTAssertTrue(int > 0 && int < 6)
    }
    
    func testRandomNumberGenerator2(){
        let testView = SKView()
        let gs = GameScene(size: testView.bounds.size)
        let int:Int = gs.randomNumber2(range: 1...2)
        XCTAssertTrue(int > 0 && int < 3)
    }
    
    func testSpawnMonster() {
        let testView = SKView()
        let gs = GameScene(size: testView.bounds.size)
        let monsterCopy = gs.spawnMonster(x: 0)
        XCTAssertNotNil(monsterCopy)
    }
    
    func testSpawnFood() {
        let testView = SKView()
        let gs = GameScene(size: testView.bounds.size)
        let foodCopy = gs.spawnFood(x: 0)
        XCTAssertNotNil(foodCopy)
    }
    
    func testupdateScoreValue() {
        let testView = SKView()
        let gs = GameScene(size: testView.bounds.size)
        let score:Int = 10
        gs.updateScoreValue(value: 10)
        XCTAssertEqual(score, gs.score)
    }
    
    func testUpdateLifeValue() {
        let testView = SKView()
        let gs = GameScene(size: testView.bounds.size)
        let lifeCount:Int = 2
        gs.updateLifeValue(value: 1)
        XCTAssertEqual(lifeCount, gs.lifeCount)
    }

    func testScreenDimensions() {
        let testView = SKView()
        let gs = GameScene(size: testView.bounds.size)
        let width:CGFloat = gs.screenWidth
        let height:CGFloat = gs.screenHeight
        XCTAssertTrue(width > 0 && height > 0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
        
    }
    
}
