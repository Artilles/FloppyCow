//
//  FloppyCow.swift
//  Floppy Cows
//
//  Created by Ray Young on 2014-10-31.
//  Copyright (c) 2014 Velocitrix. All rights reserved.
//

import Foundation
import SpriteKit

// Player
class BraveHero: SKSpriteNode
{
    enum DIR
    {
        case
        B,
        BR,
        R,
        TR,
        T,
        TL,
        L,
        BL
    }
    
    private let playerCategory: UInt32 = 0x1 << 0
    private let cowCategory: UInt32 = 0x1 << 0
    private let copCategory: UInt32 = 0x1 << 2
    
    var actionB:SKAction
    var actionBL:SKAction
    var actionL:SKAction
    var actionTL:SKAction
    var actionT:SKAction
    var actionTR:SKAction
    var actionR:SKAction
    var actionBR:SKAction
    var previousPosition:CGPoint = CGPointMake(0, 0)
    var direction = DIR.B
    
    convenience override init()
    {
        self.init(imageNamed:"BAnim1.png")
        
        
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: size.width / 2, height: size.height - 6))
        physicsBody?.dynamic = true;
        physicsBody?.categoryBitMask = playerCategory
        physicsBody?.contactTestBitMask = cowCategory | copCategory
        physicsBody?.collisionBitMask = 0
        physicsBody?.usesPreciseCollisionDetection = true
        
        //atlas.textureNamed("player1.png")
        
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        var spriteArrayB = Array<SKTexture>()
        for (var i = 1; i < 7; i++)
        {
            var name = String(format: "BAnim%i.png", i)
            spriteArrayB.append(SKTexture(imageNamed: name))
        }
        actionB = SKAction.animateWithTextures(spriteArrayB, timePerFrame: 0.20)
        actionB = SKAction.repeatActionForever(actionB)
        
        var spriteArrayBR = Array<SKTexture>()
        for (var i = 1; i < 7; i++)
        {
            var name = String(format: "BRAnim%i.png", i)
            spriteArrayBR.append(SKTexture(imageNamed: name))
        }
        actionBR = SKAction.animateWithTextures(spriteArrayBR, timePerFrame: 0.20)
        actionBR = SKAction.repeatActionForever(actionBR)
        
        var spriteArrayR = Array<SKTexture>()
        for (var i = 1; i < 7; i++)
        {
            var name = String(format: "RAnim%i.png", i)
            spriteArrayR.append(SKTexture(imageNamed: name))
        }
        actionR = SKAction.animateWithTextures(spriteArrayR, timePerFrame: 0.20)
        actionR = SKAction.repeatActionForever(actionR)
        
        var spriteArrayTR = Array<SKTexture>()
        for (var i = 1; i < 7; i++)
        {
            var name = String(format: "TRAnim%i.png", i)
            spriteArrayTR.append(SKTexture(imageNamed: name))
        }
        actionTR = SKAction.animateWithTextures(spriteArrayTR, timePerFrame: 0.20)
        actionTR = SKAction.repeatActionForever(actionTR)
        
        var spriteArrayT = Array<SKTexture>()
        for (var i = 1; i < 7; i++)
        {
            var name = String(format: "TAnim%i.png", i)
            spriteArrayT.append(SKTexture(imageNamed: name))
        }
        actionT = SKAction.animateWithTextures(spriteArrayT, timePerFrame: 0.20)
        actionT = SKAction.repeatActionForever(actionT)
        
        var spriteArrayTL = Array<SKTexture>()
        for (var i = 1; i < 7; i++)
        {
            var name = String(format: "TLAnim%i.png", i)
            spriteArrayTL.append(SKTexture(imageNamed: name))
        }
        actionTL = SKAction.animateWithTextures(spriteArrayTL, timePerFrame: 0.20)
        actionTL = SKAction.repeatActionForever(actionTL)
        
        var spriteArrayL = Array<SKTexture>()
        for (var i = 1; i < 7; i++)
        {
            var name = String(format: "LAnim%i.png", i)
            spriteArrayL.append(SKTexture(imageNamed: name))
        }
        actionL = SKAction.animateWithTextures(spriteArrayL, timePerFrame: 0.20)
        actionL = SKAction.repeatActionForever(actionL)
        
        var spriteArrayBL = Array<SKTexture>()
        for (var i = 1; i < 7; i++)
        {
            var name = String(format: "BLAnim%i.png", i)
            spriteArrayBL.append(SKTexture(imageNamed: name))
        }
        actionBL = SKAction.animateWithTextures(spriteArrayBL, timePerFrame: 0.20)
        actionBL = SKAction.repeatActionForever(actionBL)
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder decoder: NSCoder) {
        var spriteArrayB = Array<SKTexture>()
        for (var i = 1; i < 7; i++)
        {
            var name = String(format: "BAnim%i.png", i)
            spriteArrayB.append(SKTexture(imageNamed: name))
        }
        actionB = SKAction.animateWithTextures(spriteArrayB, timePerFrame: 0.20)
        actionB = SKAction.repeatActionForever(actionB)
        
        var spriteArrayBR = Array<SKTexture>()
        for (var i = 1; i < 7; i++)
        {
            var name = String(format: "BRAnim%i.png", i)
            spriteArrayBR.append(SKTexture(imageNamed: name))
        }
        actionBR = SKAction.animateWithTextures(spriteArrayBR, timePerFrame: 0.20)
        actionBR = SKAction.repeatActionForever(actionBR)
        
        var spriteArrayR = Array<SKTexture>()
        for (var i = 1; i < 7; i++)
        {
            var name = String(format: "RAnim%i.png", i)
            spriteArrayR.append(SKTexture(imageNamed: name))
        }
        actionR = SKAction.animateWithTextures(spriteArrayR, timePerFrame: 0.20)
        actionR = SKAction.repeatActionForever(actionR)
        
        var spriteArrayTR = Array<SKTexture>()
        for (var i = 1; i < 7; i++)
        {
            var name = String(format: "TRAnim%i.png", i)
            spriteArrayTR.append(SKTexture(imageNamed: name))
        }
        actionTR = SKAction.animateWithTextures(spriteArrayTR, timePerFrame: 0.20)
        actionTR = SKAction.repeatActionForever(actionTR)
        
        var spriteArrayT = Array<SKTexture>()
        for (var i = 1; i < 7; i++)
        {
            var name = String(format: "TAnim%i.png", i)
            spriteArrayT.append(SKTexture(imageNamed: name))
        }
        actionT = SKAction.animateWithTextures(spriteArrayT, timePerFrame: 0.20)
        actionT = SKAction.repeatActionForever(actionT)
        
        var spriteArrayTL = Array<SKTexture>()
        for (var i = 1; i < 7; i++)
        {
            var name = String(format: "TLAnim%i.png", i)
            spriteArrayTL.append(SKTexture(imageNamed: name))
        }
        actionTL = SKAction.animateWithTextures(spriteArrayTL, timePerFrame: 0.20)
        actionTL = SKAction.repeatActionForever(actionTL)
        
        var spriteArrayL = Array<SKTexture>()
        for (var i = 1; i < 7; i++)
        {
            var name = String(format: "LAnim%i.png", i)
            spriteArrayL.append(SKTexture(imageNamed: name))
        }
        actionL = SKAction.animateWithTextures(spriteArrayL, timePerFrame: 0.20)
        actionL = SKAction.repeatActionForever(actionL)
        
        var spriteArrayBL = Array<SKTexture>()
        for (var i = 1; i < 7; i++)
        {
            var name = String(format: "BLAnim%i.png", i)
            spriteArrayBL.append(SKTexture(imageNamed: name))
        }
        actionBL = SKAction.animateWithTextures(spriteArrayBL, timePerFrame: 0.20)
        actionBL = SKAction.repeatActionForever(actionBL)
        
        super.init(coder: decoder)
    }
    
    func UpdateHero(currentTime: CFTimeInterval)
    {
        
        zPosition = -position.y
    }
    
    func MovePlayer(x: CGFloat, y: CGFloat)
    {
        var piVal:Double = 3.14152
        var angle:Double = atan2(Double(y), Double(x)) + piVal
        
        position.x += x
        position.y += y
        
        zPosition = -position.y
        
        if (angle < piVal / 8.0 || angle >= 15 * piVal / 8)
        {
            if (direction != DIR.L)
            {
                direction = DIR.L
                self.runAction(actionL)
            }
        }
        else if (angle < 3.0 * piVal / 8.0)
        {
            if (direction != DIR.BL)
            {
                direction = DIR.BL
                self.runAction(actionBL)
            }
        }
        else if (angle < 5.0 * piVal / 8.0)
        {
            if (direction != DIR.B)
            {
                direction = DIR.B
                self.runAction(actionB)
            }
        }
        else if (angle < 7.0 * piVal / 8.0)
        {
            if (direction != DIR.BR)
            {
                direction = DIR.BR
                self.runAction(actionBR)
            }
        }
        else if (angle < 9.0 * piVal / 8.0)
        {
            if (direction != DIR.R)
            {
                direction = DIR.R
                self.runAction(actionR)
            }
        }
        else if (angle < 11.0 * piVal / 8.0)
        {
            if (direction != DIR.TR)
            {
                direction = DIR.TR
                self.runAction(actionTR)
            }
        }
        else if (angle < 13.0 * piVal / 8.0)
        {
            if (direction != DIR.T)
            {
                direction = DIR.T
                self.runAction(actionT)
            }
        }
        else if (angle < 15.0 * piVal / 8.0)
        {
            if (direction != DIR.TL)
            {
                direction = DIR.TL
                self.runAction(actionTL)
            }
        }
    }
}