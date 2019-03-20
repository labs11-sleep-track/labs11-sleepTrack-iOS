//
//  LoginViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class LoginViewController: ShiftableViewController {

    // MARK: - Properties
    @IBOutlet weak var emailTextField: SLTextField!
    @IBOutlet weak var passwordTextField: SLTextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: - UI Actions
    @IBAction func loginUser(_ sender: Any) {
        performSegue(withIdentifier: "LoginSegue", sender: self)
    }
    
    
    @IBAction func signupUser(_ sender: Any) {
        performSegue(withIdentifier: "LoginSegue", sender: self)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Utility Methods
    private func setupViews() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let gradientView = view as! GradientView
        gradientView.setupGradient(startColor: .darkerBackgroundColor, endColor: .lighterBackgroundColor)
        
        emailTextField.setPlaceholder("Email")
        passwordTextField.setPlaceholder("Password")
    }
}
