//
//  GameViewController.swift
//  COSC345.2
//
//  Created by makayla montgomery on 8/05/20.
//  Copyright © 2020 makayla montgomery. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use view as a SKView to load spritekit contents
        if let view = self.view as! SKView? {
            // Initialise scene as an instance of GameScene with size equal to screen bounds
            let scene = GameScene(size: view.bounds.size)
            // Scale mode set to allow scene contents to fill window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}
