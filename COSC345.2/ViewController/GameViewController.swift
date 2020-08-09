//  GameViewController.swift
//  swipeGestures
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let menuscene = MenuScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        menuscene.scaleMode = .resizeFill
        skView.presentScene(menuscene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
