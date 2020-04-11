//
//  MemeStorage.swift
//  MemeMe
//
//  Created by MANINDER SINGH on 11/04/20.
//  Copyright © 2020 MANINDER SINGH. All rights reserved.
//

import Foundation
import UIKit

class MemeStorage: NSObject {
    
   public static var memes = [Meme]()
    
    private override init() {
    }
    
    static func getMemes() -> [Meme] {
        return memes
    }
    
    
    
    static func get(_ position: Int) -> Meme {
        return memes[position]
    }
    
    static func getCount() -> Int {
        return memes.count
    }
}

