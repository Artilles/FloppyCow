//
//  Controller.swift
//  Floppy Cows
//
//  Created by Karin Khera on 9/26/14.
//  Copyright (c) 2014 Velocitrix. All rights reserved.
//

import Foundation
import SpriteKit


class Controller: SKSpriteNode
{
    var hitbox: (CGPoint -> Bool)?
 
    
    convenience init(named: String, position: CGPoint)
    {
        self.init(imageNamed: named)
        self.texture?.filteringMode = .Nearest
        self.setScale(2.0)
        self.alpha = 0.2
        self.position = position
        
        hitbox = {(location: CGPoint)-> Bool in return self.containsPoint(location)
        }
    }
    func hitboxContainsPoint(location : CGPoint) -> Bool
    {
        return hitbox!(location)
    }
    
    func setUpHitBox()
    {
        let l:CGFloat = 94.0
        let x0:CGFloat = -400.0
        let y0:CGFloat = -300.0
        let angle = CGFloat(tan(M_PI / 3))
        hitbox = {
            (location: CGPoint) -> Bool in
            return location.y - y0 > 0 && (abs(location.x - x0) <= abs(location.y - y0) * angle) && (pow((location.x - x0),2) + pow((location.y - y0),2) <= pow(l,2))
        }
    }
}
