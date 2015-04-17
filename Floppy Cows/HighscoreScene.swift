//
//  HighscoreScene.swift
//  Floppy Cows
//
//  Created by Zac Bell on 2014-11-03.
//  Copyright (c) 2014 Velocitrix. All rights reserved.
//

import Foundation
import SpriteKit
import Darwin
import AVFoundation

class HighscoreScene : SKScene {
    
    var _resetButton = SKSpriteNode(imageNamed: "reset_button.png")
    var _backButton = SKSpriteNode(imageNamed: "back_button.png")
    
    let scoreLabel = SKLabelNode(fontNamed:"ChalkboardSE-Bold")
    let scoreLabelBack = SKLabelNode(fontNamed:"ChalkboardSE-Bold")
    var Score = HighScore()
    var retrievedHighScore = SaveHighScore().RetrieveHighScore() as HighScore
    var soundPlayer:AVAudioPlayer = AVAudioPlayer()
    var backgroundMusicPlayer:AVAudioPlayer = AVAudioPlayer()
    var clickURL:NSURL = NSBundle.mainBundle().URLForResource("click", withExtension: "mp3")!
    var bgMusicURL:NSURL = NSBundle.mainBundle().URLForResource("menuMusic", withExtension: "mp3")!
    
    override init(size:CGSize) {
        super.init(size: size)
        let background = SKSpriteNode(imageNamed: "hscore.jpg")
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.size = self.size
        background.zPosition = -2
        self.addChild(background)
        soundPlayer = AVAudioPlayer(contentsOfURL: clickURL, error: nil)
        backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
        
        initMenu()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initMenu()
    {
        scoreLabel.text = "High Score: \(retrievedHighScore.highScore)"
        self.addChild(scoreLabel)
        scoreLabel.position.x = 300
        scoreLabel.position.y = self.size.height - 250
        scoreLabel.color = SKColor(red: 1.0, green: 0.0, blue: 0.3, alpha: 1.0)
        scoreLabel.colorBlendFactor = 1.0
        scoreLabel.zPosition = 100
        
        scoreLabelBack.text = "High Score: \(retrievedHighScore.highScore)"
        self.addChild(scoreLabelBack)
        scoreLabelBack.setScale(1.02)
        scoreLabelBack.position.x = 300
        scoreLabelBack.position.y = self.size.height - 250
        scoreLabelBack
        scoreLabelBack.color = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        scoreLabelBack.colorBlendFactor = 1.0
        scoreLabelBack.zPosition = 90
        
        // Add Reset buttons
        _resetButton.position = CGPoint(x: _resetButton.size.width / 2, y: 40)
        _resetButton.setScale(0.8)
        self.addChild(_resetButton)
        
        // Add Back button
        _backButton.position = CGPoint(x: self.size.width - (_backButton.size.width / 2), y: 40)
        _backButton.setScale(0.8)
        self.addChild(_backButton)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            // Reset button touched
            if CGRectContainsPoint(_resetButton.frame, touch.locationInNode(self)) {
                _resetButton.texture = SKTexture(imageNamed: "reset_button_pressed.png")
            }
            
            // Back button touched
            if CGRectContainsPoint(_backButton.frame, touch.locationInNode(self)) {
                _backButton.texture = SKTexture(imageNamed: "back_button_pressed.png")
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            if !CGRectContainsPoint(_resetButton.frame, touch.locationInNode(self)) {
                _resetButton.texture = SKTexture(imageNamed: "reset_button.png")
            }
            
            if !CGRectContainsPoint(_backButton.frame, touch.locationInNode(self)) {
                _backButton.texture = SKTexture(imageNamed: "back_button.png")
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            // Reset button event
            if CGRectContainsPoint(_resetButton.frame, touch.locationInNode(self)) {
                _resetButton.texture = SKTexture(imageNamed: "reset_button.png")
                resetButtonEvent()
            }
            
            // Back button event
            if CGRectContainsPoint(_backButton.frame, touch.locationInNode(self)) {
                backButtonEvent()
            }
        }
    }
    
    /* Callback function for the Reset button. */
    func resetButtonEvent() {
        soundPlayer.prepareToPlay()
        soundPlayer.play()
        Score.highScore = 0
        SaveHighScore().ArchiveHighScore(highScore: Score)
        let scene = HighscoreScene(size: self.size)
        scene.scaleMode = .AspectFill
        self.view?.presentScene(scene)
    }
    
    /* Callback function for Back button. Changes scene to MenuScene. */
    func backButtonEvent() {
        soundPlayer.prepareToPlay()
        soundPlayer.play()
        let scene = MenuScene(size: self.size)
        scene.scaleMode = .AspectFill
        self.view?.presentScene(scene)
    }
}