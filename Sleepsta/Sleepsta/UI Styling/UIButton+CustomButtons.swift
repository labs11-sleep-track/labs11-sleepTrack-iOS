//
//  UIButton+CustomButtons.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/4/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

extension UIButton {
    
    static func customButton(with title: String? = nil, with accentColor: AccentColor = .normal) -> UIButton {
        let button = UIButton()
        if let title = title {
            button.setTitle(title, for: .normal)
        }
        button.setTitleColor(accentColor.color(), for: .normal)
        button.tintColor = accentColor.color()
        return button
    }
    
}

enum AccentColor {
    case normal, negative
    
    func color() -> UIColor {
        switch self {
        case .normal: return .accentColor
        case .negative: return .pink
        }
    }
}
