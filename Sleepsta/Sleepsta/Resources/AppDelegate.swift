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
        
        if User.loadUser() {
            presentLoggedInVC(animated: false)
        } else {
            presentLoginVC(animated: false)
        }

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance()!.handle(url as URL?, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
    }
    
    

    // MARK: - GID Sign In Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Error signing in: \(error)")
        } else {
            let idToken = user.authentication.idToken!
            let needToRefresh = User.current == nil
            
            User.sleepstaSignIn(idToken) { (error) in
                DispatchQueue.main.async {
                    if error == nil {
                        if needToRefresh {
                            self.presentLoggedInVC()
                        }
                    } else {
                        GIDSignIn.sharedInstance()?.disconnect()
                    }
                }
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        User.removeUser()
        presentLoginVC()
    }
    
    // MARK: - Utility Methods
    private func presentLoggedInVC(animated: Bool = true) {
        if User.current != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyboard.instantiateViewController(withIdentifier: .tabBarController)
            setRootViewController(tabBarController, animated: animated)
        }
    }
    
    private func presentLoginVC(animated: Bool = true) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: .loginViewController)
        setRootViewController(loginViewController, animated: animated)
    }
    
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }
        
        DispatchQueue.main.async {
            window.rootViewController = vc
            window.makeKeyAndVisible()
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            
        }
    }
}

