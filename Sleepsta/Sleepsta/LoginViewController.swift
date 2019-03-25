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
    
    @IBOutlet weak var emailTextField: SLTextField!
    @IBOutlet weak var passwordTextField: SLTextField!
    @IBOutlet weak var firstNameTextField: SLTextField!
    @IBOutlet weak var lastNameTextField: SLTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
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
        if User.current != nil { performSegue(withIdentifier: "LoginSegue", sender: self)}
    }
    
    // MARK: - UI Actions
    @IBAction func toggleLogin(_ sender: UISegmentedControl) {
        setLoginButtons(to: sender.selectedSegmentIndex == 0)
    }
    
    @IBAction func loginUser(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "LoginSegue", sender: self)
        }
    }
    
    @IBAction func signupUser(_ sender: Any) {
//        guard let email = emailTextField.text, let password = passwordTextField.text, let firstName = firstNameTextField.text, let lastName = lastNameTextField.text else { return }
//        let user = User(email: email, password: password, firstName: firstName, lastName: lastName)
//
//        loginManager.login(user, with: .register) {
//            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: "LoginSegue", sender: self)
//            }
//        }
    }

    // MARK: - Utility Methods
    private func setupViews() {
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        signInButton.colorScheme = .dark
        
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        let gradientView = view as! GradientView
        gradientView.setupGradient(startColor: .darkerBackgroundColor, endColor: .lighterBackgroundColor)
        
        emailTextField.setPlaceholder("Email")
        passwordTextField.setPlaceholder("Password")
        firstNameTextField.setPlaceholder("First Name")
        lastNameTextField.setPlaceholder("Last Name")
        
        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        setLoginButtons(to: true)
    }
    
    private func setLoginButtons(to bool: Bool) {
        loginButton.isHidden = bool
        signupButton.isHidden = bool
        firstNameTextField.isHidden = bool
        lastNameTextField.isHidden = bool
    }
}
