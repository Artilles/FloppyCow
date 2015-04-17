//
//  Operators.swift
//  Floppy Cows
//
//  Created by Karin Khera on 9/27/14.
//  Copyright (c) 2014 Velocitrix. All rights reserved.
//

import Foundation
import UIKit

infix operator ** { associativity left precedence 160 }
func ** (left: CGFloat, right: CGFloat) -> CGFloat! {
    return pow(left, right)
}
infix operator **= { associativity right precedence 90 }
func **= (inout left: CGFloat, right: CGFloat) {
    left = left ** right
}
