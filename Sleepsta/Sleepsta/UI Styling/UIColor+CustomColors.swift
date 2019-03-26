//
//  UIColor+CustomColors.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let darkerBackgroundColor = UIColor(hexRed: 0, green: 0, blue: 0)
    static let lighterBackgroundColor = UIColor(hexRed: 20, green: 20, blue: 20)
    static let accentColor = UIColor(hexRed: 0, green: 122, blue: 255)
    
    /// Convenience initializer for making UIColors from HEX values
    convenience init(hexRed: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) {
        self.init(red: hexRed/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
}
