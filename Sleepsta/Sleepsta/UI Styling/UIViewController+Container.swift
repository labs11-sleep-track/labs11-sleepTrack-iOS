//
//  UIViewController+Container.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/13/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

extension UIViewController {
    func add(_ child: UIViewController, toView: UIView? = nil) {
        let parentView = toView == nil ? view! : toView!
        addChild(child)
        child.view.constrainToFill(parentView)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
