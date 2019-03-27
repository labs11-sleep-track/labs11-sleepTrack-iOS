//
//  LoginViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: ShiftableViewController, GIDSignInUIDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if User.current != nil { performSegue(withIdentifier: "LoginSegue", sender: self)}
    }
    

    // MARK: - Utility Methods
    private func setupViews() {
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        signInButton.colorScheme = .dark
        
        let gradientView = view as! GradientView
        gradientView.setupGradient(startColor: .darkerBackgroundColor, endColor: .lighterBackgroundColor)
    }
}
