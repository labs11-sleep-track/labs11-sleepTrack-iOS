//
//  UILabel+CustomLabels.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/4/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

extension UILabel {
    static func titleLabel(with title: String, and color: UIColor = .customWhite) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = color
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return titleLabel
    }
    
    static func subtitleLabel(with title: String, and color: UIColor = .customWhite) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = color
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        return titleLabel
    }
}
