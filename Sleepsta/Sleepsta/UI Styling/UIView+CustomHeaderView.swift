//
//  UIView+CustomHeaderView.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/2/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Returns a view suitable for being the header view of a table view section with the given string and color.
    static func customHeaderView(with title: String, with color: UIColor = .customWhite) -> UIView {
        let view = UIView()
        let label = UILabel()
        label.textColor = color
        label.text = title
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        return view
    }
}
