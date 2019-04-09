//
//  LoginViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: SLViewController, GIDSignInUIDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    var signInButton: GIDSignInButton!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    @IBAction func signInWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    // MARK: - Utility Methods
    private func setupViews() {
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        titleLabel.textColor = .customWhite
    }
}
