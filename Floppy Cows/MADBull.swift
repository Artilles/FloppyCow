//
//  MADBull.swift
//  Floppy Cows
//
//  Created by Ryan Cairney on 2014-11-03.
//  Copyright (c) 2014 Velocitrix. All rights reserved.
//

import Foundation
import spritekit
import Darwin

class MADBull : SKSpriteNode
{
    var rampageTime : CGFloat = 60.0;
    var rampageTimer : CGFloat = 0.0;
    var rampageInterval : CGFloat = 1.0;
    var rampageCounter : CGFloat = 1.0;
    var rampageSpeed : CGFloat = 2.0;
    var playerPos: CGPoint = CGPoint(x:0,y: 0);
    var rampageVector :CGPoint = CGPoint(x :0, y :0);
    var pathLineMod :CGPoint = CGPoint(x :2, y :4);
    var cowSpeed : CGFloat = 10;
    private let playerCategory: UInt32 = 0x1 << 0
    private let madBullCategory: UInt32 = 0x1 << 3
    var lockOnPlayer : Bool = false
    var direction : CGPoint = CGPoint(x :0, y :0);
    var madBullID : Int = 0
    
    convenience override init()
    {
        self.init(imageNamed:"alienbull")
        xScale = 0.15
        yScale = 0.15
        zRotation = 0.5;
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.dynamic = true
        physicsBody?.categoryBitMask = madBullCategory
        physicsBody?.contactTestBitMask = playerCategory
        physicsBody?.collisionBitMask = 0
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func UpdateBull(currentTime: CFTimeInterval)
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
            
            rampageTimer += 0.1;
            rampageCounter += 0.1;
        }
        else{
            position.x += speed*5;
        }
        
        zPosition = -position.y;
        
    }
    func update()
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
            
            rampageTimer += 0.1;
            rampageCounter += 0.1;
        }
        else{
            //position.x += speed*5;
            if(!lockOnPlayer)
            {
                direction = CGPoint(x: playerPos.x - self.frame.midX, y: playerPos.y - self.frame.midY)
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
        }
        
        zPosition = -position.y;
        
    }
    func setPlayerPos(pos : CGPoint)
    {
        playerPos = pos;
    }
}
