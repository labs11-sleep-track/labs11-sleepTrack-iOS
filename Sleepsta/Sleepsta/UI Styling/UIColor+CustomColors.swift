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
    static let fadedDarkBlue = UIColor(hexRed: 76, green: 84, blue: 111, alpha: 0.5)
    static let customWhite = UIColor(hexRed: 247, green: 247, blue: 255)
    static let lightGreen = UIColor(hexRed: 158, green: 228, blue: 147)
    static let pink = UIColor(hexRed: 227, green: 74, blue: 111)
    static let mintGreen = UIColor(hexRed: 154, green: 210, blue: 203)
    static let systemBlue = UIColor(hexRed: 0, green: 122, blue: 255)
    
    static let accentColor = UIColor.lightGreen
    
    /// Convenience initializer that returns a UIColor from HEX values
    convenience init(hexRed: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) {
        self.init(red: hexRed/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    /// Convenience initializer that returns a UIColor from a HEX string
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        // Make a character set that will strip whitespace and #'s
        var characterSet = CharacterSet.whitespacesAndNewlines
        characterSet.insert(charactersIn: "#")
        // Use it to format the hex string
        let cString = hex.components(separatedBy: characterSet).joined().uppercased()
        
        // For now, if it is not exactly 6 characters, return nil
        // TODO: Update to take a 3 character hex code
        if (cString.count != 6) { return nil }
        
        // Scan the hex number into an Int
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        // Do some fancy hex math and initialize a UIColor
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)
        let green = CGFloat((rgbValue & 0x00FF00) >> 8)
        let blue = CGFloat(rgbValue & 0x0000FF)
        self.init(hexRed: red, green: green, blue: blue, alpha: alpha)
    }
}
