//
//  MenuScene.swift
//  Floppy Cows
//
//  Created by Zac Bell on 2014-10-09.
//  Copyright (c) 2014 Velocitrix. All rights reserved.
//

import SpriteKit
import Darwin
import AVFoundation

class MenuScene: SKScene {
    
    //let skView = self.view as SKView
    var _playButton:SKSpriteNode = SKSpriteNode(imageNamed: "play_button.png")
    var _highscoreButton:SKSpriteNode = SKSpriteNode(imageNamed: "highscore_button.png")
    var _quitButton:SKSpriteNode = SKSpriteNode(imageNamed: "quit_button.png")
    var _teamLabel:SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
    var soundPlayer:AVAudioPlayer = AVAudioPlayer()
    //var backgroundMusicPlayer:AVAudioPlayer = AVAudioPlayer()
    var clickURL:NSURL = NSBundle.mainBundle().URLForResource("click", withExtension: "mp3")!
    var menuMusicURL:NSURL = NSBundle.mainBundle().URLForResource("menuMusic", withExtension: "mp3")!
    
    override init(size:CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor.greenColor()
        
        // Load in and add the menu background image
        let background = SKSpriteNode(imageNamed: "menu_bg.jpg")
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.size = self.size
        background.zPosition = -2
        self.addChild(background)
        soundPlayer = AVAudioPlayer(contentsOfURL: clickURL, error: nil)
        /*backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: menuMusicURL, error: nil)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()*/
        
        initMenu()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Menu Initialization
    func initMenu()
    {
        // Add Play button
        _playButton.position = CGPoint(x: (self.size.width / 2) + 3, y: self.size.height / 2 + 150)
        _playButton.setScale(0.6)
        self.addChild(_playButton)
        
        // Add Highscores button
        _highscoreButton.position = CGPoint(x: (self.size.width / 2) + 3, y: self.size.height / 2 + 75)
        _highscoreButton.setScale(0.6)
        self.addChild(_highscoreButton)
        
        // Add Quit button
        _quitButton.position = CGPoint(x: (self.size.width / 2) + 3, y: self.size.height / 2)
        _quitButton.setScale(0.6)
        self.addChild(_quitButton)
        
        _teamLabel.text = "Team Velocitrix"
        _teamLabel.setScale(0.8)
        _teamLabel.color = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        _teamLabel.colorBlendFactor = 1.0
        _teamLabel.position = CGPoint(x: self.size.width - 130, y: 40)
        self.addChild(_teamLabel)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            // Play button touched
            if CGRectContainsPoint(_playButton.frame, touch.locationInNode(self)) {
                _playButton.texture = SKTexture(imageNamed: "play_button_pressed.png")
            }
            
            // Highscore button touched
            if CGRectContainsPoint(_highscoreButton.frame, touch.locationInNode(self)) {
                _highscoreButton.texture = SKTexture(imageNamed: "highscore_button_pressed.png")
            }
            
            // Quit button touched
            if CGRectContainsPoint(_quitButton.frame, touch.locationInNode(self)) {
                _quitButton.texture = SKTexture(imageNamed: "quit_button_pressed.png")
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            // Play button is being touched, change image
            if CGRectContainsPoint(_playButton.frame, touch.locationInNode(self)) {
                _playButton.texture = SKTexture(imageNamed: "play_button_pressed.png")
            } else {
                // Play button not being touched, change the image back to normal
                _playButton.texture = SKTexture(imageNamed: "play_button.png")
            }
            
            // Highscore button is being touched, change image
            if CGRectContainsPoint(_highscoreButton.frame, touch.locationInNode(self)) {
                _highscoreButton.texture = SKTexture(imageNamed: "highscore_button_pressed.png")
            } else {
                // Highscore button not being touched, change the image back to normal
                _highscoreButton.texture = SKTexture(imageNamed: "highscore_button.png")
            }
        
            // Quit button is being touched, change image
            if CGRectContainsPoint(_quitButton.frame, touch.locationInNode(self)) {
                _quitButton.texture = SKTexture(imageNamed: "quit_button_pressed.png")
            } else {
                // Quit button is not being touched, change the image back to normal
                _quitButton.texture = SKTexture(imageNamed: "quit_button.png")
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            // Play button event
            if CGRectContainsPoint(_playButton.frame, touch.locationInNode(self)) {
                playButtonEvent()
            }
            
            // Highscore button event
            if CGRectContainsPoint(_highscoreButton.frame, touch.locationInNode(self)) {
                highscoreButtonEvent();
            }
            
            // Quit button event
            if CGRectContainsPoint(_quitButton.frame, touch.locationInNode(self)) {
                quitButtonEvent()
            }
        }
    }
    
    /* Callback event for Play button. */
    func playButtonEvent() {
        soundPlayer.prepareToPlay()
        soundPlayer.play()
        backgroundMusicPlayer.pause()
        let scene = GameScene(size: self.size)
        scene.scaleMode = .AspectFill
        self.view?.presentScene(scene)
    }
    
    /* Callback event for Highscore button. */
    func highscoreButtonEvent() {
        soundPlayer.prepareToPlay()
        soundPlayer.play()
        let scene = HighscoreScene(size: self.size)
        scene.scaleMode = .AspectFill
        self.view?.presentScene(scene)
    }
    
    /* Callback event for Quit button. */
    func quitButtonEvent() {
        soundPlayer.prepareToPlay()
        soundPlayer.play()
        exit(EXIT_SUCCESS)
    }
}
