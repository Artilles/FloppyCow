//
//  GameScene.swift
//  Floppy Cows
//
//  Created by Jon Bergen on 2014-09-20.
//  Copyright (c) 2014 Velocitrix. All rights reserved.
//

import SpriteKit
import Darwin
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player:BraveHero = BraveHero()
    var lastYieldTimeInterval:NSTimeInterval = NSTimeInterval()
    var lastUpdateTimerInterval:NSTimeInterval = NSTimeInterval()
    var keepMoving:Bool = false
    var touchLocation:CGPoint = CGPointMake(0, 0)
    var desinationPoint : CGPoint!
    var background = SKSpriteNode(imageNamed: "grass.png")
    
    var Score = HighScore()
    var retrievedHighScore = SaveHighScore().RetrieveHighScore() as HighScore
    var newHighScore:Bool = false;
    var highScoreImage = SKSpriteNode(imageNamed: "highscoreimage.png")

    var rotate:CGFloat = 180
    
    var cowList = Dictionary<Int, FloppyCow>()
    var copList = Dictionary<Int, AngryCop>()
    var madBullList = Dictionary<Int, MADBull>()
    var copAndCowList = Dictionary<Int, SKSpriteNode>()
    var availableCowPositions = Dictionary<Int, CGPoint>()
    var occupiedCowPositions = Dictionary<Int, CGPoint>()
    var copAndCowCount:Int = 0
    var cowCount:Int = 0
    var copCount:Int = 0
    var madBullCount:Int = 0
    let scoreLabel = SKLabelNode(fontNamed:"ChalkboardSE-Bold")
    let timerLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
    let copMultiplierLabel = SKLabelNode(fontNamed:"ChalkboardSE-Bold")
    let cowsTippedLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
    var cowsTipped:Double = 0
    var timer:Double = 0
    var madtimer:Double = 0
    var score:Double = 0
    var timeMultiplier:Double = 1
    var copMultiplier:Double = 1
    var tipScore:Double = 0
    var currentCows = 0
    var madBullCurrentCows = 0
    var copTimer:NSTimeInterval = NSTimeInterval()
    var isPaused:Bool = false
    var pauseTouched = false
    var addCowToList = false
    var dropCow = false
    var copPosIndex = 0
    var cowToDrop = FloppyCow()
    var cowBeam = CowBeam()
    
    var dyingCow = FloppyCow()
    
    var clickURL:NSURL = NSBundle.mainBundle().URLForResource("click", withExtension: "mp3")!
    var beamSoundURL:NSURL = NSBundle.mainBundle().URLForResource("beam", withExtension: "mp3")!
    var cowTipSoundURL:NSURL = NSBundle.mainBundle().URLForResource("cowDown", withExtension: "mp3")!
    var bgMusicURL:NSURL = NSBundle.mainBundle().URLForResource("To Glory", withExtension: "mp3")!
    var menuMusicURL:NSURL = NSBundle.mainBundle().URLForResource("menuMusic", withExtension: "mp3")!
    var walkSoundURL:NSURL = NSBundle.mainBundle().URLForResource("step", withExtension: "mp3")!
    var soundPlayer:AVAudioPlayer = AVAudioPlayer()
    var walkPlayer:AVAudioPlayer = AVAudioPlayer()
    
    //Initialize the buttons
    var _pauseButton:SKSpriteNode = SKSpriteNode(imageNamed: "pause_button_50alpha.png")
    var _playButton:SKSpriteNode = SKSpriteNode(imageNamed: "play_button.png")
    var _quitButton:SKSpriteNode = SKSpriteNode(imageNamed: "menu_button.png")
    var _tapButton:SKSpriteNode = SKSpriteNode(imageNamed: "tap.png")
    //var _transparentBG:SKShapeNode = SKShapeNode()
    
    //temp
    var cow:SKSpriteNode = FloppyCow()
    
    //SwipGesture
    var swipedLeft:Bool = false
    var swipedRight:Bool = false
    var swipedUp:Bool = false
    var swipedDown:Bool = false
    //collsion
    var isCollide:Bool = false//if the player is colliding with cow
    private let playerCategory: UInt32 = 0x1 << 0
    private let copCategory: UInt32 = 0x1 << 2
    private let cowCategory:UInt32 = 0x1 << 1
    private let madBullCategory: UInt32 = 0x1 << 3
    
    var numOfTap:Int = 0
    var numReqTap = 1;
    var cowToRemove:SKSpriteNode = FloppyCow()
    var tapEngaged:Bool = false;
    var tapTimer:Double = 0;
    
    override func didMoveToView(view: SKView) {
        Settings.sharedInstance.dPad = false

        //loading swip gesture
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeRight:")
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeLeft:")
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeUp:")
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeDown:")

        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        swipeRecognizer.numberOfTouchesRequired = 2
        swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        swipeLeftRecognizer.numberOfTouchesRequired = 2
        swipeUpRecognizer.direction = UISwipeGestureRecognizerDirection.Up
        swipeUpRecognizer.numberOfTouchesRequired = 2
        swipeDownRecognizer.direction = UISwipeGestureRecognizerDirection.Down
        swipeDownRecognizer.numberOfTouchesRequired = 2
        
        view.addGestureRecognizer(swipeRecognizer)
        view.addGestureRecognizer(swipeLeftRecognizer)
        view.addGestureRecognizer(swipeUpRecognizer)
        view.addGestureRecognizer(swipeDownRecognizer)
        

        // Add Pause button
        _pauseButton.position = CGPoint(x: self.size.width / 2, y: self.size.height - 35)
        _pauseButton.setScale(0.8)
        self.addChild(_pauseButton)
        _pauseButton.zPosition = 100
    
        _playButton.position = CGPoint(x: (self.size.width / 2) + 3, y: self.size.height / 2 + 40)
        _playButton.setScale(0.6)
        _playButton.zPosition = 100
        
        _quitButton.position = CGPoint(x: (self.size.width / 2) + 3, y: (self.size.height / 2) - 40)
        _quitButton.setScale(0.6)
        _quitButton.zPosition = 100
    }
    
    override init(size:CGSize){
        super.init(size: size)
        self.backgroundColor = SKColor.brownColor()
        
        highScoreImage.position = CGPoint(x:self.frame.width - 310, y:self.frame.height - 25);
        highScoreImage.setScale(0.15)
        highScoreImage.zRotation = 0.5
        
        //Initialize Player
        player.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        player.setScale(1.2)
        self.addChild(player)
        
        player.position.x = self.size.width / 2
        player.position.y = self.size.height / 2
        self.addChild(timerLabel)
        self.addChild(scoreLabel)
        self.addChild(copMultiplierLabel)
        self.addChild(cowsTippedLabel)
        self.addChild(background)
        background.zPosition = -100000
        background.size = self.size
        background.position = CGPointMake(self.size.width / 2, self.size.height / 2)
        
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        
        soundPlayer = AVAudioPlayer(contentsOfURL: clickURL, error: nil)
        //walkPlayer = AVAudioPlayer(contentsOfURL: walkSoundURL, error: nil)
        
        var posID:Int = 0
        for (var i = 0; i < 15; i++)
        {
            for (var j = 0; j < 20; j++)
            {
                var h = CGFloat(j) * (size.width - 100) / 20
                var v = CGFloat(i) * (size.height - 100) / 15
                availableCowPositions[posID] = CGPointMake(50 + h, 50 + v)
                posID++
            }
        }
        
        backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
        backgroundMusicPlayer.volume = 1.0
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    }
    
    func addCop()
    {
        var cop:AngryCop = AngryCop()
        
        if (copPosIndex == 0)
        {
            cop.position = CGPointMake(self.size.width / 2, self.size.height + 75)
        }
        else if (copPosIndex == 1)
        {
            cop.position = CGPointMake(-75, self.size.height / 2)
        }
        else if (copPosIndex == 2)
        {
            cop.position = CGPointMake(self.size.width / 2, -75)
        }
        else
        {
            cop.position = CGPointMake(self.size.width + 75, self.size.height / 2)
        }

        copPosIndex++

        if (copPosIndex == 4)
        {
            copPosIndex = 0
        }

        cop.SetPlayer(player)
        
        copList[copCount] = cop
        copCount++
        copAndCowList[copAndCowCount] = cop
        copAndCowCount++
        
        self.addChild(cop)
    }
    
    func addCow(){
        cowToDrop = FloppyCow()
        cowToDrop.cowID = cowCount
        let arr = Array(availableCowPositions.values)
        let index: Int = Int(arc4random_uniform(UInt32(arr.count)))
        var pos = arr[index]
        
        

        
        cowToDrop.targetPosition = pos
        cowToDrop.position = CGPointMake(pos.x, self.size.height + 50)
        dropCow = true
        cowBeam.position = cowToDrop.targetPosition
        cowToDrop.zPosition = -cowToDrop.targetPosition.y
        
        cowToDrop.posIndex = index
        occupiedCowPositions[index] = pos
        availableCowPositions.removeValueForKey(index)
        
        self.addChild(cowToDrop)
        cowBeam.removeFromParent()
        soundPlayer = AVAudioPlayer(contentsOfURL: beamSoundURL, error: nil)
        soundPlayer.volume = 0.3
        //soundPlayer.prepareToPlay()
        soundPlayer.play()
        self.addChild(cowBeam)
    }
    func addWarn(pos : CGPoint)
    {
        let warn = Warning()
        
        warn.setPostion(CGPoint(x: pos.x, y: pos.y - 10))
        self.addChild(warn)
    }
    func updateTimeSinceLasUpdate(timeSinceLastUpdate:NSTimeInterval){
     
        lastYieldTimeInterval += timeSinceLastUpdate
        if (lastYieldTimeInterval > 2.0){
            lastYieldTimeInterval = 0
            if (currentCows < 25)
            {
                addCow()
            }
        }
        
        copTimer += timeSinceLastUpdate
        if (copTimer > 5.0 && copCount < 20)
        {
            copTimer = 0
            addCop()
            copMultiplier += 0.1
        }
        madtimer += timeSinceLastUpdate
        
        if(tapEngaged)
        {
            
            tapTimer += timeSinceLastUpdate
            
            if( tapTimer > 0.25)
            {
                tapTimer = 0;
                if(_tapButton.alpha == 1)
                {
                    _tapButton.alpha = 0.5
                }
                else
                {
                    _tapButton.alpha = 1
                }
            }
        }
        for cow in cowList
        {
            cow.1.incrementTime(timeSinceLastUpdate);
            if(cow.1.madTimer > 10 && cow.1.isMad == false)
            {
                cow.1.isMad = true;
                cow.1.warn.setPostion(cow.1.position);
                self.addChild(cow.1.warn)
            }
        
        }

        
    }
    
    func move(location:CGPoint){
        
        var moveX = location.x - player.position.x
        var moveY = location.y - player.position.y
        
        var mag : CGFloat = sqrt(moveX * moveX + moveY * moveY)
        
        if (mag < 4.5)
        {
            player.position = location
        }
        else
        {
            player.position.x += moveX * 4.5 / mag
            player.position.y += moveY * 4.5 / mag
        }
        
        player.zRotation = rotate;
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if(touches.count > 1) {
                desinationPoint = nil
            } else {
                desinationPoint = location
                if(isCollide)
                {
                    numOfTap++
                }
            }
            
            
            if(!isPaused) {
                // Pause button touched and the game is not paused
                if CGRectContainsPoint(_pauseButton.frame, touch.locationInNode(self)) {
                    _pauseButton.texture = SKTexture(imageNamed: "pause_button.png")
                    pauseTouched = true
                }
            } else {
                // GAME IS PAUSED
                if CGRectContainsPoint(_playButton.frame, touch.locationInNode(self)) {
                    _playButton.texture = SKTexture(imageNamed: "play_button_pressed.png")
                }
                if CGRectContainsPoint(_quitButton.frame, touch.locationInNode(self)) {
                    _quitButton.texture = SKTexture(imageNamed: "menu_button_pressed.png")
                }
            }
            
            touchLocation = location
            keepMoving = true
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let previousLocation = touch.previousLocationInNode(self)
            
            if(touches.count > 1) {
                desinationPoint = nil
            } else {
                desinationPoint = location
            }
            
            if(!isPaused) {
                // Pause button touched
                if pauseTouched && CGRectContainsPoint(_pauseButton.frame, touch.locationInNode(self)) {
                    _pauseButton.texture = SKTexture(imageNamed: "pause_button.png")
                } else {
                    pauseTouched = false
                    _pauseButton.texture = SKTexture(imageNamed: "pause_button_50alpha.png")
                }
            } else {
                if CGRectContainsPoint(_playButton.frame, touch.locationInNode(self)) {
                    _playButton.texture = SKTexture(imageNamed: "play_button_pressed.png")
                } else {
                    _playButton.texture = SKTexture(imageNamed: "play_button.png")
                }
                
                if CGRectContainsPoint(_quitButton.frame, touch.locationInNode(self)) {
                    _quitButton.texture = SKTexture(imageNamed: "menu_button_pressed.png")
                } else {
                    _quitButton.texture = SKTexture(imageNamed: "menu_button.png")
                }
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch : AnyObject in touches
        {
            let location = touch.locationInNode(self)
            let previousLocation = touch.previousLocationInNode(self)
            
            desinationPoint = nil
            
            if(!isPaused) {
                if pauseTouched && CGRectContainsPoint(_pauseButton.frame, touch.locationInNode(self)) {
                    soundPlayer = AVAudioPlayer(contentsOfURL: clickURL, error: nil)
                    soundPlayer.prepareToPlay()
                    soundPlayer.play()
                    isPaused = true
                }
            } else {
                if CGRectContainsPoint(_playButton.frame, touch.locationInNode(self)) {
                    soundPlayer = AVAudioPlayer(contentsOfURL: clickURL, error: nil)
                    soundPlayer.prepareToPlay()
                    soundPlayer.play()
                    isPaused = false
                    _playButton.texture = SKTexture(imageNamed: "play_button.png")
                    _pauseButton.texture = SKTexture(imageNamed: "pause_button_50alpha.png")
                    _playButton.removeFromParent()
                    _quitButton.removeFromParent()
                    self.childNodeWithName("TransparentBG")?.removeFromParent()
                }
                if CGRectContainsPoint(_quitButton.frame, touch.locationInNode(self)) {
                    soundPlayer = AVAudioPlayer(contentsOfURL: clickURL, error: nil)
                    soundPlayer.prepareToPlay()
                    soundPlayer.play()
                    backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: menuMusicURL, error: nil)
                    backgroundMusicPlayer.numberOfLoops = -1
                    backgroundMusicPlayer.prepareToPlay()
                    backgroundMusicPlayer.play()
                    isPaused = false
                    let scene = MenuScene(size: self.size)
                    scene.scaleMode = .AspectFill
                    self.view?.presentScene(scene)
                }
            }
        }
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        for touch : AnyObject in touches
        {
            let location = touch.locationInNode(self)
            let previousLocation = touch.previousLocationInNode(self)
            
            desinationPoint = nil
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
       
        
        if (!isPaused)
        {
            if(numOfTap > numReqTap)//flips the cow
            {
                dyingCow = cowToRemove as FloppyCow
                dyingCow.isAlive = false
                handleCowCollsion(cowToRemove as FloppyCow)
                numOfTap = 0;
            }
            else
            {
                /*if(!dyingCow.isAlive)
                {
                    dyingCow.zRotation = -1.75
                    dyingCow.texture = SKTexture(imageNamed: "mama_cow_falling.png")
                    dyingCow.setDeadCategory()
                    if(dyingCow.alpha > -1)
                    {
                        dyingCow.alpha -= 0.01;
                    }
                    else
                    {
                        dyingCow.removeFromParent()
                        dyingCow = FloppyCow()
                    }
                }*/
            }
            var timeSinceLastUpdate = currentTime - lastUpdateTimerInterval
            lastUpdateTimerInterval = currentTime
            timer += currentTime
            if(timeSinceLastUpdate > 1){
                timeSinceLastUpdate = 1/60
                lastUpdateTimerInterval = currentTime
                timeMultiplier+=0.1
            }
            
            score += tipScore
            tipScore = 0
            
            if (Int(score) > retrievedHighScore.highScore && !newHighScore)
            {
                newHighScore = true
                self.addChild(highScoreImage)
                //highScoreImage.runAction(SKAction.moveToY(self.size.height, duration: 2.0))
            }
            /*if (highScoreImage.position.y == self.size.height)
            {
                highScoreImage.removeFromParent()
            }*/
        
            timerLabel.text = "Time: \(Int(timer/36000000))s"
            timerLabel.fontSize = 25;
            timerLabel.position = CGPoint(x:70, y:self.frame.height - 25);
            scoreLabel.text = "Score: \(Int(score)) x\(copMultiplier * timeMultiplier)"
            scoreLabel.fontSize = 25;
            scoreLabel.position = CGPoint(x:self.frame.width - 150, y:self.frame.height - 25);
            /*copMultiplierLabel.text = "Score Multiplier: x\(copMultiplier * timeMultiplier)"
            copMultiplierLabel.fontSize = 25;
            copMultiplierLabel.position = CGPoint(x:self.frame.width - 150, y:self.frame.height - 50);
            cowsTippedLabel.text = "Cows Tipped: \(cowsTipped)"
            cowsTippedLabel.fontSize = 25;
            cowsTippedLabel.position = CGPoint(x:self.frame.width - 150, y:self.frame.height - 75);*/
        
            var walkingSpeed: CGFloat = 4.0
        

                if desinationPoint != nil
                {
                    let direction = CGPoint(x: desinationPoint.x - player.frame.midX, y: desinationPoint.y - player.frame.midY)
                    let mag = sqrt(direction.x ** 2 + direction.y ** 2 )
                    let normalizedDirection  = CGPoint(x: direction.x / mag, y: direction.y / mag)
                
                    if (mag < walkingSpeed) {
                        player.MovePlayer(direction.x, y: direction.y)
                        //walkPlayer.prepareToPlay()
                        //walkPlayer.play()
                    } else {
                        player.MovePlayer(normalizedDirection.x * walkingSpeed, y: normalizedDirection.y * walkingSpeed)
                        //walkPlayer.prepareToPlay()
                        //walkPlayer.play()
                    }
                }
            
            // Update each cop for collision avoidance
            for cop in copList
            {
                cop.1.UpdateCop(currentTime, copsAndCows: copAndCowList)
            }
            if (dropCow)
            {
                cowToDrop.UpdateCow(currentTime)
                
                if (cowToDrop.ready)
                {
                    dropCow = false
                    
                    cowList[cowToDrop.cowID] = cowToDrop
                    cowCount++
                    currentCows++
                    
                    copAndCowList[copAndCowCount] = cowToDrop
                    copAndCowCount++
                    
                    cowToDrop.zPosition = -cowToDrop.position.y
                    cowBeam.removeFromParent()
                }
            }
            var cowsRemoved = Dictionary<Int, FloppyCow>()
            for cow in cowList
            {
                if(cow.1.isCharging && !cow.1.removedWarning)
                {
                    cow.1.warn.removeFromParent()
                    cow.1.removedWarning = true
                    copAndCowList[cow.1.cowID] = nil
                }
                if(cow.1.isMad == true)
                {
                    cow.1.UpdateCow(currentTime)
                    cow.1.setPlayerPos(player.position)
                    if (cow.1.removeCow)
                    {
                        currentCows--
                        cow.1.warn.removeFromParent()
                        cow.1.removeFromParent()
                        cowsRemoved[cow.0] = cow.1
                    }
                    if(cow.1.isCharging && !cow.1.removedWarning)
                    {
                        cow.1.warn.removeFromParent()
                        cow.1.removedWarning = true
                    }
                }
                if(!cow.1.isAlive)
                {
                    cow.1.zRotation = -1.75
                    cow.1.texture = SKTexture(imageNamed: "mama_cow_falling.png")
                    cow.1.setDeadCategory()
                    //cow.1.isMad = false;
                    if(cow.1.alpha > 0)
                    {
                        cow.1.alpha -= 0.01
                    }
                    else
                    {
                        cow.1.removeFromParent()
                        cow.1.warn.removeFromParent()
                        
                        cowsRemoved[cow.0] = cow.1
                        copAndCowList.removeValueForKey(cow.1.cowID)
                        //cowList.removeValueForKey(cow.1.cowID)
                        currentCows--
                    }
                }
            }
            
            for cow in cowsRemoved
            {
                cowList.removeValueForKey(cow.0)
            }
            
            updateTimeSinceLasUpdate(timeSinceLastUpdate)
        
            /*Going to touched location
            if(keepMoving){
                move(touchLocation)
            }*/
        } else {
            // GAME IS PAUSED
            // Draw transparent rectangle
            if(self.childNodeWithName("TransparentBG") == nil)
            {
                let bounds = CGRect(origin: CGPoint.zeroPoint, size: CGSize(width: self.size.width, height: self.size.width))
                var rectangleNode = SKShapeNode(rect: bounds)
                rectangleNode.fillColor = UIColor.blackColor()
                rectangleNode.alpha = 0.45
                rectangleNode.blendMode = SKBlendMode.Alpha
                rectangleNode.name = "TransparentBG"
                self.addChild(rectangleNode)
            }
            
            if(_playButton.parent == nil) {
                self.addChild(_playButton)
            }
            if(_quitButton.parent == nil) {
                self.addChild(_quitButton)
            }
        }
    }
    
    /* Fired when the player enters the hitbox of a cow. */
    func didBeginContact(contact: SKPhysicsContact!) {
        var firstBody : SKPhysicsBody
        var secondBody : SKPhysicsBody
        
        // We want to sort these bodies by their bitmasks so that it's easier
        // to identify which body belongs to which sprite.
        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //Detects the collison between the cow and palyer
        if((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & cowCategory) != 0)
        {
            //cowtipped
            isCollide = true
            _tapButton.setScale(0.6)
            _tapButton.zPosition = 100
            var x: CGFloat
            
            cowToRemove = secondBody.node as FloppyCow
            if(!tapEngaged)
            {
                _tapButton.position.x = cowToRemove.position.x
                _tapButton.position.y = cowToRemove.position.y + 25
                self.addChild(_tapButton)
                numOfTap = 0;
                tapEngaged = true;
            }
           
        }else
        {
            isCollide = false;
        }
        //Detects the collsion between the cop and player
        if((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & copCategory) != 0)
        {
            if (Int(score) > retrievedHighScore.highScore)
            {
                Score.highScore = Int(score)
                SaveHighScore().ArchiveHighScore(highScore: Score)
            }
            backgroundMusicPlayer.pause()
            let scene = GameOverScene(size: self.size)
            scene.SetScore(Int(score))
            scene.scaleMode = .AspectFill
            self.view?.presentScene(scene)
            
        }
        if((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & madBullCategory) != 0)
        {
            if (Int(score) > retrievedHighScore.highScore)
            {
                Score.highScore = Int(score)
                SaveHighScore().ArchiveHighScore(highScore: Score)
            }
            backgroundMusicPlayer.pause()
            let scene = GameOverScene(size: self.size)
            scene.SetScore(Int(score))
            scene.scaleMode = .AspectFill
            self.view?.presentScene(scene)
        }
    }
    //When the player leaves the object bounding box
    func didEndContact(contact: SKPhysicsContact) {
        var firstBody : SKPhysicsBody
        var secondBody : SKPhysicsBody
        
        // We want to sort these bodies by their bitmasks so that it's easier
        // to identify which body belongs to which sprite.
        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //Detects the collison between the cow and palyer
        if((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & cowCategory) != 0)
        {
            //cowtipped
            if(tapEngaged)
            {
                _tapButton.removeFromParent()
                tapEngaged = false;
            }
            
        }
        //Detects the collsion between the cop and player
        if((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & copCategory) != 0)
        {
        }
        
    }
    
    func handleCowCollsion(theCow : FloppyCow)
    {
        //theCow.isAlive = false
        if(tapEngaged)
        {
        //var temp1 = copAndCowList.removeValueForKey(theCow.cowID)
        //var temp2 = cowList.removeValueForKey(theCow.cowID)
        cowList[theCow.cowID]?.isAlive = false;
        cowList[theCow.cowID]?.warn.removeFromParent();
        
        //theCow.warn.removeFromParent()
        //theCow.removeFromParent()
        _tapButton.removeFromParent()
            
        soundPlayer = AVAudioPlayer(contentsOfURL: cowTipSoundURL, error: nil)
        //soundPlayer.prepareToPlay()
        soundPlayer.volume = 0.3
        soundPlayer.play()
        
        //availableCowPositions[theCow.posIndex] = occupiedCowPositions[theCow.posIndex]
        //occupiedCowPositions.removeValueForKey(theCow.posIndex)
        
        tapEngaged = false
        numOfTap = 0
        
        cowsTipped++
        tipScore += copMultiplier * timeMultiplier * 100
        }
    }
    @IBAction func swipeRight(swipe: UISwipeGestureRecognizer)
    {
        //println("swiping right")
        if(isCollide)
        {
            swipedLeft = true
        }
    }
    @IBAction func swipeLeft(swipe: UISwipeGestureRecognizer)
    {
        //println("swiping left")
        if(isCollide)
        {
            swipedUp = true
        }
    }
    @IBAction func swipeUp(swipe: UISwipeGestureRecognizer)
    {
        //println("swiping up")
        if(isCollide)
        {
            swipedUp = true
        }
    }
    @IBAction func swipeDown(swipe: UISwipeGestureRecognizer)
    {
        //println("swiping Down")
        if(isCollide)
        {
            swipedDown = true
        }
    }

}
