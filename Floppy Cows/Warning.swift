//
//  Warning.swift
//  Floppy Cows
//
//  Created by Karin Khera on 2014-12-05.
//  Copyright (c) 2014 Velocitrix. All rights reserved.
//

import Foundation
import SpriteKit

class Warning: SKSpriteNode
{
    
    convenience override init()
    {
        self.init(imageNamed:"warning")
        xScale = 1
        yScale = 0.75
        self.alpha = 0.1
        
    }

    func setPostion(pos : CGPoint)
    {
        self.position.x = pos.x
        self.position.y = pos.y + 65
    }
    func increaseAlpha(val : CGFloat)
    {
        self.alpha += val;
    }
    func addToChild()
    {
        self.addChild(self)
    }
    func updatePos(pos : CGPoint)
    {
        self.position = pos;
    }
}