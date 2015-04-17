//
//  FloppyCow.swift
//  Floppy Cows
//
//  Created by Ray Young on 2014-10-31.
//  Copyright (c) 2014 Velocitrix. All rights reserved.
//

import Foundation
import SpriteKit

// Cop
class AngryCop: SKSpriteNode
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
    
    var player : SKSpriteNode
    var moveSpeed : CGFloat = 2.0
    private let copCategory: UInt32 = 0x1 << 2
    private let playerCategory: UInt32 = 0x1 << 0
    
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
        self.init(imageNamed:"BCopAnim1.png")
        xScale = 1.0
        yScale = 1.0
        //physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: size.width - (size.width / 4), height: size.height - (size.height / 4)))
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: size.width / 4, height: size.height / 4))
        physicsBody?.dynamic = true
        physicsBody?.categoryBitMask = copCategory
        physicsBody?.contactTestBitMask = playerCategory
        physicsBody?.collisionBitMask = 0
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        player = SKSpriteNode()
        var spriteArrayB = Array<SKTexture>()
        for (var i = 1; i < 5; i++)
        {
            var name = String(format: "BCopAnim%i.png", i)
            spriteArrayB.append(SKTexture(imageNamed: name))
        }
        actionB = SKAction.animateWithTextures(spriteArrayB, timePerFrame: 0.20)
        actionB = SKAction.repeatActionForever(actionB)
        
        var spriteArrayBR = Array<SKTexture>()
        for (var i = 1; i < 5; i++)
        {
            var name = String(format: "BRCopAnim%i.png", i)
            spriteArrayBR.append(SKTexture(imageNamed: name))
        }
        actionBR = SKAction.animateWithTextures(spriteArrayBR, timePerFrame: 0.20)
        actionBR = SKAction.repeatActionForever(actionBR)
        
        var spriteArrayR = Array<SKTexture>()
        for (var i = 1; i < 5; i++)
        {
            var name = String(format: "RCopAnim%i.png", i)
            spriteArrayR.append(SKTexture(imageNamed: name))
        }
        actionR = SKAction.animateWithTextures(spriteArrayR, timePerFrame: 0.20)
        actionR = SKAction.repeatActionForever(actionR)
        
        var spriteArrayTR = Array<SKTexture>()
        for (var i = 1; i < 5; i++)
        {
            var name = String(format: "TRCopAnim%i.png", i)
            spriteArrayTR.append(SKTexture(imageNamed: name))
        }
        actionTR = SKAction.animateWithTextures(spriteArrayTR, timePerFrame: 0.20)
        actionTR = SKAction.repeatActionForever(actionTR)
        
        var spriteArrayT = Array<SKTexture>()
        for (var i = 1; i < 5; i++)
        {
            var name = String(format: "TCopAnim%i.png", i)
            spriteArrayT.append(SKTexture(imageNamed: name))
        }
        actionT = SKAction.animateWithTextures(spriteArrayT, timePerFrame: 0.20)
        actionT = SKAction.repeatActionForever(actionT)
        
        var spriteArrayTL = Array<SKTexture>()
        for (var i = 1; i < 5; i++)
        {
            var name = String(format: "TLCopAnim%i.png", i)
            spriteArrayTL.append(SKTexture(imageNamed: name))
        }
        actionTL = SKAction.animateWithTextures(spriteArrayTL, timePerFrame: 0.20)
        actionTL = SKAction.repeatActionForever(actionTL)
        
        var spriteArrayL = Array<SKTexture>()
        for (var i = 1; i < 5; i++)
        {
            var name = String(format: "LCopAnim%i.png", i)
            spriteArrayL.append(SKTexture(imageNamed: name))
        }
        actionL = SKAction.animateWithTextures(spriteArrayL, timePerFrame: 0.20)
        actionL = SKAction.repeatActionForever(actionL)
        
        var spriteArrayBL = Array<SKTexture>()
        for (var i = 1; i < 5; i++)
        {
            var name = String(format: "BLCopAnim%i.png", i)
            spriteArrayBL.append(SKTexture(imageNamed: name))
        }
        actionBL = SKAction.animateWithTextures(spriteArrayBL, timePerFrame: 0.20)
        actionBL = SKAction.repeatActionForever(actionBL)
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder decoder: NSCoder) {
        player = SKSpriteNode()
        var spriteArrayB = Array<SKTexture>()
        for (var i = 1; i < 5; i++)
        {
            var name = String(format: "BCopAnim%i.png", i)
            spriteArrayB.append(SKTexture(imageNamed: name))
        }
        actionB = SKAction.animateWithTextures(spriteArrayB, timePerFrame: 0.20)
        actionB = SKAction.repeatActionForever(actionB)
        
        var spriteArrayBR = Array<SKTexture>()
        for (var i = 1; i < 5; i++)
        {
            var name = String(format: "BRCopAnim%i.png", i)
            spriteArrayBR.append(SKTexture(imageNamed: name))
        }
        actionBR = SKAction.animateWithTextures(spriteArrayBR, timePerFrame: 0.20)
        actionBR = SKAction.repeatActionForever(actionBR)
        
        var spriteArrayR = Array<SKTexture>()
        for (var i = 1; i < 5; i++)
        {
            var name = String(format: "RCopAnim%i.png", i)
            spriteArrayR.append(SKTexture(imageNamed: name))
        }
        actionR = SKAction.animateWithTextures(spriteArrayR, timePerFrame: 0.20)
        actionR = SKAction.repeatActionForever(actionR)
        
        var spriteArrayTR = Array<SKTexture>()
        for (var i = 1; i < 5; i++)
        {
            var name = String(format: "TRCopAnim%i.png", i)
            spriteArrayTR.append(SKTexture(imageNamed: name))
        }
        actionTR = SKAction.animateWithTextures(spriteArrayTR, timePerFrame: 0.20)
        actionTR = SKAction.repeatActionForever(actionTR)
        
        var spriteArrayT = Array<SKTexture>()
        for (var i = 1; i < 5; i++)
        {
            var name = String(format: "TACopnim%i.png", i)
            spriteArrayT.append(SKTexture(imageNamed: name))
        }
        actionT = SKAction.animateWithTextures(spriteArrayT, timePerFrame: 0.20)
        actionT = SKAction.repeatActionForever(actionT)
        
        var spriteArrayTL = Array<SKTexture>()
        for (var i = 1; i < 5; i++)
        {
            var name = String(format: "TLCopAnim%i.png", i)
            spriteArrayTL.append(SKTexture(imageNamed: name))
        }
        actionTL = SKAction.animateWithTextures(spriteArrayTL, timePerFrame: 0.20)
        actionTL = SKAction.repeatActionForever(actionTL)
        
        var spriteArrayL = Array<SKTexture>()
        for (var i = 1; i < 5; i++)
        {
            var name = String(format: "LCopAnim%i.png", i)
            spriteArrayL.append(SKTexture(imageNamed: name))
        }
        actionL = SKAction.animateWithTextures(spriteArrayL, timePerFrame: 0.20)
        actionL = SKAction.repeatActionForever(actionL)
        
        var spriteArrayBL = Array<SKTexture>()
        for (var i = 1; i < 5; i++)
        {
            var name = String(format: "BLCopAnim%i.png", i)
            spriteArrayBL.append(SKTexture(imageNamed: name))
        }
        actionBL = SKAction.animateWithTextures(spriteArrayBL, timePerFrame: 0.20)
        actionBL = SKAction.repeatActionForever(actionBL)
        
        super.init(coder: decoder)
    }
    
    func SetPlayer(player:SKSpriteNode)
    {
        self.player = player
    }
    
    func UpdateCop(currentTime: CFTimeInterval, copsAndCows: Dictionary<Int, SKSpriteNode>)
    {
        var totalWeight = 1;
        
        var moveX : CGFloat = player.position.x - self.position.x
        var moveY : CGFloat = player.position.y - self.position.y
        
        var magnitude : CGFloat = sqrt(moveX * moveX + moveY * moveY)
        
        var distSpeed : CGFloat = 0.25
        
        if (magnitude < 300 && magnitude > 100)
        {
            var ratio = (300 - magnitude) / 300
            distSpeed += ratio * 0.75
        }
        else if (magnitude <= 100)
        {
            distSpeed = 1.0
        }
        
        moveX /= magnitude
        moveY /= magnitude
        
        var separateX : CGFloat = 0
        var separateY : CGFloat = 0
        
        for sprite in copsAndCows
        {
            if (self != sprite.1)
            {
                var sepX : CGFloat = self.position.x - sprite.1.position.x
                var sepY : CGFloat = self.position.y - sprite.1.position.y
                var dist : CGFloat = sqrt(sepX * sepX + sepY * sepY)
                
                var tooCloseDist : CGFloat = sprite.1.size.width / 2
                var sepDist : CGFloat = tooCloseDist * 1.15
                
                if (dist < sepDist)
                {
                    dist = max(0.0, dist - tooCloseDist)
                    var sepRange = sepDist - tooCloseDist
                    
                    //var sepFactor = (acos((sepRange - dist) / sepRange) * 2 - 0.5) / 3.14152
                    
                    separateX += sepX// * sepFactor
                    separateY += sepY// * sepFactor
                }
            }
        }
        
        var vX : CGFloat = moveX + separateX
        var vY : CGFloat = moveY + separateY
        var vMag : CGFloat = sqrt(vX * vX + vY * vY)
        
        self.position.x += vX * distSpeed * moveSpeed / vMag
        self.position.y += vY * distSpeed * moveSpeed / vMag
        
        var piVal:Double = 3.14152
        var angle:Double = atan2(Double(moveY), Double(moveX)) + piVal
        
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
        
        
        self.zPosition = -position.y
    }
}