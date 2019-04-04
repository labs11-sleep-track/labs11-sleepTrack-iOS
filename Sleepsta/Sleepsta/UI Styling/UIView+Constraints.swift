//
//  UIView+Constraints.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/4/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Adds the view it is called on to the given view and constrains it to fill that view, with options to use the view's safe area and offsets from each side.
    func constrainToFill(_ view: UIView, safeArea: Bool = false, top: CGFloat = 0.0, bottom: CGFloat = 0.0, leading: CGFloat = 0.0, trailing: CGFloat = 0.0) {
        
        addAsSubviewWithConstraintsOf(view)
        
        let topAnchor = safeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor
        let bottomAnchor = safeArea ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor
        let leadingAnchor = safeArea ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor
        let trailingAnchor = safeArea ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor
        
        self.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
        bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottom).isActive = true
        self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading).isActive = true
        trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailing).isActive = true
    }
    
    /// Adds the view it is called on to the given view and optionally constrains it to each anchor that is given a value, with an option to use the view's safe area. **It is possible to define conflicting constraints, beware.**
    func constrainToSuperView(_ view: UIView, safeArea: Bool = true, top: CGFloat? = nil, bottom: CGFloat? = nil, leading: CGFloat? = nil, trailing: CGFloat? = nil, centerX: CGFloat? = nil, centerY: CGFloat? = nil) {
        
        addAsSubviewWithConstraintsOf(view)
        
        if let top = top {
            let topAnchor = safeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor
            self.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
        }
        
        if let bottom = bottom {
            let bottomAnchor = safeArea ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor
            bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottom).isActive = true
        }
        
        if let leading = leading {
            let leadingAnchor = safeArea ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor
            self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading).isActive = true
        }
        
        if let trailing = trailing {
            let trailingAnchor = safeArea ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor
            trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailing).isActive = true
        }
        
        if let centerX = centerX {
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: centerX).isActive = true
        }
        
        if let centerY = centerY {
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: centerY).isActive = true
        }
        
    }
    
    /// Adds the view it is called on as a subview of the given view and constrains it to the center, with optional offsets.
    func constrainToCenterIn(_ view: UIView, xOffset: CGFloat = 0, yOffset: CGFloat = 0) {
        
        addAsSubviewWithConstraintsOf(view)
        
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: xOffset).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yOffset).isActive = true
    }
    
    /// Adds the view it is called on as a subview of the given view and turns translatesAutoresizingMaskIntoConstraints off
    private func addAsSubviewWithConstraintsOf(_ view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
    }
}
