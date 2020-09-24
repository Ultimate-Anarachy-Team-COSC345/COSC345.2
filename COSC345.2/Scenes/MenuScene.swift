//
//  MenuScene.swift
//  swipeGestures
//
//  Created by Brittany Duncan on 7/08/20.
//

//import Foundation
import SpriteKit
import AVFoundation

public class MenuScene: SKScene {
    let playButton = SKLabelNode(fontNamed: "Arial-BoldMT")
    var backgroundMusic: AVAudioPlayer?
    var background = SKSpriteNode(imageNamed:"menubackground")
    override init(size: CGSize) {
        super.init(size: size)
        //backgroundColor = SKColor.white
        playButton.fontColor = SKColor()
        playButton.color = UIColor.red
        playButton.text = "Tap to Start!"
        playButton.position = CGPoint(x: size.width / 2, y: 70)
        addChild(playButton)
        background.size = (self.frame.size)
        background.position = CGPoint(x: background.size.width/2,y: background.size.height/2)
        background.zPosition = -1
        addChild(background)
        
    }
        public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMove(to view: SKView) {
        let path = Bundle.main.path(forResource: "SUPERMARKET MUSIC", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: url)
            backgroundMusic?.play()
        }  catch {
            // couldn't load file :(
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            let reveal = SKTransition.doorsOpenVertical(withDuration: 0.5)
            let difficultyScene = DifficultyScene(size:self.size)
            self.view?.presentScene(difficultyScene, transition: reveal)
    }
}
