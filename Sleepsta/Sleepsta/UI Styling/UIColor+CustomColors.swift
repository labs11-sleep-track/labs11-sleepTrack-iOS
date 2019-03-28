//
//  UIColor+CustomColors.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let darkerBackgroundColor = UIColor(hexRed: 7, green: 15, blue: 30)
    static let lighterBackgroundColor = UIColor(hexRed: 37, green: 46, blue: 79)
    static let darkBlue = UIColor(hexRed: 76, green: 84, blue: 111)
    static let customWhite = UIColor(hexRed: 247, green: 247, blue: 255)
    static let lightGreen = UIColor(hexRed: 158, green: 228, blue: 147)
    static let pink = UIColor(hexRed: 227, green: 74, blue: 111)
    static let mintGreen = UIColor(hexRed: 154, green: 210, blue: 203)
    static let systemBlue = UIColor(hexRed: 0, green: 122, blue: 255)
    
    static let accentColor = UIColor.lightGreen
    
    /// Convenience initializer for making UIColors from HEX values
    convenience init(hexRed: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) {
        self.init(red: hexRed/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
}
