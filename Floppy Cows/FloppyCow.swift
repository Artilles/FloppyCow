//
//  FloppyCow.swift
//  Floppy Cows
//
//  Created by Ray Young on 2014-10-31.
//  Copyright (c) 2014 Velocitrix. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

// Cow
class FloppyCow : SKSpriteNode
{
    private let cowCategory: UInt32 = 0x1 << 1
    private let playerCategory: UInt32 = 0x1 << 0
    private let madBullCategory: UInt32 = 0x1 << 3
    private let deadCategory: UInt32 = 0x1 << 5
    var cowID : Int = 0
    
    var targetPosition : CGPoint;
    var ready = false;
    var textureChanged = false;
    var rnd = arc4random_uniform(2)
    var posIndex : Int = -1;
    
    var soundPlayer:AVAudioPlayer = AVAudioPlayer()
    var mooPlayer:AVAudioPlayer = AVAudioPlayer()
    var mooURL:NSURL = NSBundle.mainBundle().URLForResource("moo", withExtension: "mp3")!
    var gallopURL:NSURL = NSBundle.mainBundle().URLForResource("gallop", withExtension: "mp3")!
    
    //MadBull
    var madTimer : Double = 0
    var rampageTime : CGFloat = 60.0;
    var rampageTimer : CGFloat = 0.0;
    var rampageInterval : CGFloat = 1.0;
    var rampageCounter : CGFloat = 1.0;
    var rampageSpeed : CGFloat = 1.0;
    var isMad : Bool = false;
    var isCharging : Bool = false
    var removedWarning : Bool = false;
    
    var playerPos: CGPoint = CGPoint(x:0,y: 0);
    var rampageVector :CGPoint = CGPoint(x :0, y :0);
    var pathLineMod :CGPoint = CGPoint(x :2, y :4);
    var cowSpeed : CGFloat = 10;
    
    var lockOnPlayer : Bool = false
    var isAlive : Bool = true;
    var direction : CGPoint = CGPoint(x :0, y :0);
    var madBullID : Int = 0
    var removeCow = false;
    //var warnSprite : SKSpriteNode
    var warn: Warning = Warning()
    
    var temp : CGFloat = 1.0;
    
    //fade
    var isFade : Bool = false;

    convenience override init()
    {
        // init then swap texture if the arc4random generated number is 0
        // 0 is facing bottom left, 1 is facing bottom right
        self.init(imageNamed: "mama_cow_falling2")
        if(rnd == 0) {
            self.texture = SKTexture(imageNamed:"mama_cow_falling")
        }
        
        xScale = 0.35
        yScale = 0.35
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.dynamic = true
        physicsBody?.categoryBitMask = cowCategory
        physicsBody?.contactTestBitMask = playerCategory
        physicsBody?.collisionBitMask = 0
        
        soundPlayer = AVAudioPlayer(contentsOfURL: gallopURL, error: nil)
        mooPlayer = AVAudioPlayer(contentsOfURL: mooURL, error: nil)
        //warnSprite = SKSpriteNode(imageNamed: "warning")
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        targetPosition = CGPoint(x: 0, y: 0)
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder decoder: NSCoder) {
        targetPosition = CGPoint(x: 0, y: 0)
        super.init(coder: decoder)
    }
    
    func SetCowID(ID: Int)
    {
        cowID = ID
    }
    func incrementTime(time : Double)
    {
        madTimer += time;
    }
    func gettingMad()
    {
        if(rampageCounter >= rampageInterval){
            rampageTimer += 0.1;
            rampageCounter += 0.1;
        }
    }
    func switchToMadCow()
    {
        physicsBody = SKPhysicsBody(circleOfRadius: (size.width / 3.5))
        physicsBody?.dynamic = true
        physicsBody?.categoryBitMask = madBullCategory
        physicsBody?.contactTestBitMask = playerCategory
        physicsBody?.collisionBitMask = 0
        
       // if(rnd == 0) {
        //    self.texture = SKTexture(imageNamed: "redcow_horizontal_Right.png")
//            self.texture = SKTexture(imageNamed: "redcow_horizontal_Left.png")
        //}
    }
    func UpdateCow(currentTime: CFTimeInterval)
    {
        if (!ready)
        {
            position.y -= 15
            if (position.y < targetPosition.y)
            {
                // cow has landed
                ready = true
                position.y = targetPosition.y
                
                // switch the cow texture after landing
                if (rnd == 1) {
                    self.texture = SKTexture(imageNamed: "Mama_Cow")
                } else {
                    self.texture = SKTexture(imageNamed: "mama_cow2")
                }
                
            }
        }
        else if(ready)
        {
            rampage()
        }
    }
    
    func rampage()
    {
        if(rampageTime > rampageTimer){
            if(rampageCounter >= rampageInterval){
                
                
                rampageVector.x = self.position.x-CGFloat(arc4random_uniform(1024));
                rampageVector.y = self.position.y-CGFloat(arc4random_uniform(768));
                var hypotonuse : CGFloat = sqrt((rampageVector.x * rampageVector.x) + (rampageVector.y * rampageVector.y));
                rampageVector.x = (rampageVector.x / hypotonuse);
                rampageVector.y = (rampageVector.y / hypotonuse);
                
                rampageVector.x *= CGFloat(arc4random())%2 == 0 ? -1 : 1;
                rampageVector.y *= CGFloat(arc4random())%2 == 0 ? -1 : 1;
                
                rampageVector.x *= rampageSpeed;
                rampageVector.y *= rampageSpeed;
                
                rampageCounter = 0.0;
                zRotation = -zRotation;
                
            }
            self.position.x += rampageVector.x;
            self.position.y += rampageVector.y;
            warn.setPostion(self.position)
            
            rampageTimer += 0.1;
            rampageCounter += 0.1;
            warn.alpha = (rampageTimer/rampageTime)

        }
        else{
            //position.x += speed*5;
            switchToMadCow()
            isCharging = true
            //mooPlayer.prepareToPlay()
            mooPlayer.play()
            //soundPlayer.prepareToPlay()
            soundPlayer.volume = 0.3
            soundPlayer.play()
            if(!lockOnPlayer)
            {
                direction = CGPoint(x: playerPos.x - position.x, y: playerPos.y - position.y)
                
                
                var temp : CGPoint  = CGPoint(x: 0, y: 0)
                temp.x = direction.x - self.position.x
                //temp.y = self.position.y - direction.y
                if(direction.x <  0)
                {
                    
                    self.texture = SKTexture(imageNamed: "redcow_horizontal_Left.png")

                }
                else if(direction.x >= 0)
                {
                    
                    self.texture = SKTexture(imageNamed: "redcow_horizontal_Right.png")
                }
                
                if(direction.x > -20 && direction.x < 20 && direction.y > 0)
                {
                        self.texture = SKTexture(imageNamed: "Cow BUtt.png")
                }
                
                //self.texture = SKTexture(imageNamed: "Cow BUtt.png")
                
                lockOnPlayer = true
            }
            
            
            let mag = sqrt(direction.x ** 2 + direction.y ** 2 )
            let normalizedDirection  = CGPoint(x: direction.x / mag, y: direction.y / mag)
            
            if (mag < cowSpeed) {
                self.position = playerPos
            } else {
                self.position.x  += normalizedDirection.x * cowSpeed
                self.position.y  += normalizedDirection.y * cowSpeed
            }
            
            if (position.x > 1200 || position.x < -100 || position.y > 900 || position.y < -100)
            {
                removeCow = true
            }
        }
        
        zPosition = -position.y;
    }
    func setPlayerPos(pos : CGPoint)
    {
        playerPos = pos;
    }
    func setDeadCategory()
    {
        physicsBody?.contactTestBitMask = deadCategory
        physicsBody?.categoryBitMask =  madBullCategory
    }
    
    
}