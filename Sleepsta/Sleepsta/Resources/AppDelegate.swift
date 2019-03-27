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
        signIn?.disconnect()
//        signIn?.signInSilently()

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance()!.handle(url as URL?, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
}

