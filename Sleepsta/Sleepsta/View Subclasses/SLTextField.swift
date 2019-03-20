//
//  SLTextField.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class SLTextField: UITextField {
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
    
        self.updateAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.updateAppearance()
    }
    
    func setPlaceholder(_ placeholderString: String) {
        let attributedPlaceHolderString = NSAttributedString(string: placeholderString, attributes: [.foregroundColor: UIColor.accentColor])
        attributedPlaceholder = attributedPlaceHolderString
    }
    
    private func updateAppearance() {
        backgroundColor = .clear
        layer.borderColor = UIColor.accentColor.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 6
        textColor = .white
        tintColor = .white
        
        keyboardAppearance = .dark
    }
    
}
