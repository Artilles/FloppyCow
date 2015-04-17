//
//  Settings.swift
//  Floppy Cows
//
//  Created by Karin Khera on 9/27/14.
//  Copyright (c) 2014 Velocitrix. All rights reserved.
//

import Foundation

private let _settingsInstance = Settings()

//allows us to have dpad accessible anywhere in the game
class Settings {
    var dPad = true
    
    class var sharedInstance: Settings {
        return _settingsInstance
    }
}