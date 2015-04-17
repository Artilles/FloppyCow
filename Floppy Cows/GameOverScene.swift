//
//  GameOverScene.swift
//  Floppy Cows
//
//  Created by Jon Bergen on 2014-11-05.
//  Copyright (c) 2014 Velocitrix. All rights reserved.
//

import SpriteKit
import Darwin
import AVFoundation

class GameOverScene: SKScene {
    
    var _gameOverText:SKSpriteNode = SKSpriteNode(imageNamed: "gameoverlogo.png")
    var _gameOverPic:SKSpriteNode = SKSpriteNode(imageNamed: "alienCows.jpg")
    var _playButton:SKSpriteNode = SKSpriteNode(imageNamed: "playagain_button.png")
    var _quitButton:SKSpriteNode = SKSpriteNode(imageNamed: "menu2_button.png")
    let scoreLabel = SKLabelNode(fontNamed:"ChalkboardSE-Bold")
    
    var soundPlayer:AVAudioPlayer = AVAudioPlayer()
    var menuMusicURL:NSURL = NSBundle.mainBundle().URLForResource("menuMusic", withExtension: "mp3")!
    
    var score : Int = 0
    
    override init(size:CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor.whiteColor()
        
        initMenu()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Menu Initialization
    func initMenu()
    {
        // Add GameOver Picture
        _gameOverPic.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        _gameOverPic.setScale(2)
        _gameOverPic.zPosition = -2
        self.addChild(_gameOverPic)
        
        // Add Game Over text
        _gameOverText.position = CGPoint(x: (self.size.width / 2) + 3, y: self.size.height / 2 + 250)
        _gameOverText.setScale(0.2)
        self.addChild(_gameOverText)
        
        // Add Play button
        _playButton.position = CGPoint(x: _playButton.size.width / 2, y: 40)
        _playButton.setScale(0.8)
        self.addChild(_playButton)
        
        // add Menu button
        _quitButton.position = CGPoint(x: self.size.width - (_quitButton.size.width / 2), y: 40)
        _quitButton.setScale(0.8)
        self.addChild(_quitButton)
        
        var mooURL:NSURL = NSBundle.mainBundle().URLForResource("gameover", withExtension: "mp3")!
        soundPlayer = AVAudioPlayer(contentsOfURL: mooURL, error: nil)
        soundPlayer.prepareToPlay()
        soundPlayer.play()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            // Reset button touched
            if CGRectContainsPoint(_playButton.frame, touch.locationInNode(self)) {
                _playButton.texture = SKTexture(imageNamed: "playagain_button_pressed.png")
            }
            
            // Back button touched
            if CGRectContainsPoint(_quitButton.frame, touch.locationInNode(self)) {
                _quitButton.texture = SKTexture(imageNamed: "menu2_button_pressed.png")
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            if !CGRectContainsPoint(_playButton.frame, touch.locationInNode(self)) {
                _playButton.texture = SKTexture(imageNamed: "playagain_button.png")
            }
            
            if !CGRectContainsPoint(_quitButton.frame, touch.locationInNode(self)) {
                _quitButton.texture = SKTexture(imageNamed: "menu2_button.png")
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            // Play button touched
            if CGRectContainsPoint(_playButton.frame, touch.locationInNode(self)) {
                playButtonPressed()
            }
            
            // Quit button touched
            if CGRectContainsPoint(_quitButton.frame, touch.locationInNode(self)) {
                quitButtonPressed()
            }
            
        }
    }
    
    // Callback event for Play button
    func playButtonPressed() {
        let scene = GameScene(size: self.size)
        scene.scaleMode = .AspectFill
        self.view?.presentScene(scene)
    }
    
    // Callback event for Quit button
    func quitButtonPressed() {
        backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: menuMusicURL, error: nil)
        backgroundMusicPlayer.play()
        let scene = MenuScene(size: self.size)
        scene.scaleMode = .AspectFill
        self.view?.presentScene(scene)
    }
    
    func SetScore(finalScore : Int)
    {
        score = finalScore
        scoreLabel.text = "Final Score: \(finalScore)"
        self.addChild(scoreLabel)
        scoreLabel.position.x = self.size.width / 2
        scoreLabel.position.y = self.size.height - 35
        scoreLabel.color = SKColor(red: 1.0, green: 0.0, blue: 0.3, alpha: 1.0)
        scoreLabel.colorBlendFactor = 1.0
        scoreLabel.zPosition = 100
    }
}