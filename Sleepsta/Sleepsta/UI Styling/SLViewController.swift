//
//  SLViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/3/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class SLViewController: UIViewController {
    
    /// Returns the view as a gradient view
    var gradientView: GradientView {
        return view as! GradientView
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientView = GradientView()
        gradientView.setupGradient(startColor: .darkerBackgroundColor, endColor: .lighterBackgroundColor)
        view = gradientView
    }

}
