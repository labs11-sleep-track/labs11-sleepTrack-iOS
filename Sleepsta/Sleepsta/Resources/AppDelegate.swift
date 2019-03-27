//
//  AppDelegate.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.isIdleTimerDisabled = true
        
        let signIn = GIDSignIn.sharedInstance()
        signIn?.clientID = "923724344364-hani6pf71d8u9msnnbkab3egh5j9n8gm.apps.googleusercontent.com"
        signIn?.delegate = self
//        signIn?.disconnect()
        signIn?.signInSilently()

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance()!.handle(url as URL?, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
    }

    // MARK: - GID Sign In Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Error signing in: \(error.localizedDescription)")
        } else {
            let userID = user.userID!
            let idToken = user.authentication.idToken!
            let firstName = user.profile.givenName
            let lastName = user.profile.familyName
            let email = user.profile.email!
            
            signInWithSleepsta(idToken)
            
            User.current = User(googleID: userID, email: email, idToken: idToken, firstName: firstName, lastName: lastName)
            if let rootVC = window?.rootViewController {
                rootVC.performSegue(withIdentifier: "LoginSegue", sender: self)
            } else {
                presentLoggedInVC()
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        User.current = nil
    }
    
    // MARK: - Utility Methods
    private func presentLoggedInVC() {
        if User.current != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            window?.rootViewController = tabBarController
            window?.makeKeyAndVisible()
        }
    }
    
    private func signInWithSleepsta(_ idToken: String) {
        // Build the request
        let requestURL = URL(string: "https://sleepsta.herokuapp.com/auth/google/tokenSignIn")!
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        
        let data = ["idToken": idToken]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: data)
            print(String(data: requestData, encoding: .utf8)!)
            request.httpBody = requestData
        } catch {
            NSLog("Unable to encode user: \(data)\nWith error: \(error)")
            return
        }
        
        // Make a datatask
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check for errors
            if let error = error {
                print(error)
            }
            
            // Check if any data was returned
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "Couldn't turn data into String")
            }
            }.resume()
    }
}

