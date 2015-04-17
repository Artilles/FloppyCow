//
//  CowBeam.swift
//  Floppy Cows
//
//  Created by Ray Young on 2014-10-31.
//  Copyright (c) 2014 Velocitrix. All rights reserved.
//

import Foundation
import SpriteKit

// Cow
class CowBeam : SKSpriteNode
{
    var targetPosition : CGPoint;
    var ready = false;
    
    convenience override init()
    {
        self.init(imageNamed:"cowbeam")
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
}