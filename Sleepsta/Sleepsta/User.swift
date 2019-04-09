//
//  User.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation
import GoogleSignIn
import KeychainSwift

class User: Codable {
    static var current: User? = nil
    
    /// Loads a saved user if one exists and sets the current user to the result
    @discardableResult static func loadUser() -> Bool {
        let keychain = KeychainSwift()
        guard let sleepstaIDString = keychain.get(.sleepstaID),
            let sleepstaID = Int(sleepstaIDString),
            let sleepstaToken = keychain.get(.sleepstaToken),
            let accountType = keychain.get(.userAccountType),
            let email = UserDefaults.standard.string(forKey: .userEmail) else { return false }
        
        let firstName = UserDefaults.standard.string(forKey: .userFirstName)
        let lastName = UserDefaults.standard.string(forKey: .userLastName)
        
        User.current = User(sleepstaID: sleepstaID, sleepstaToken: sleepstaToken, email: email, accountType: accountType, firstName: firstName, lastName: lastName)
        
        User.updateUserData()
        
        return true
    }
    
    /// Signs the user in to Sleepsta and sets the current user to the result.
    static func sleepstaSignIn(_ idToken: String, completion: @escaping (Error?) -> Void) {
        // Build the request
        let requestURL = URL(string: .authURLString)!.appendingPathComponent("google").appendingPathComponent("tokenSignIn")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        let data = ["token": idToken]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: data)
            print(String(data: requestData, encoding: .utf8)!)
            request.httpBody = requestData
        } catch {
            NSLog("Unable to encode user: \(data)\nWith error: \(error)")
            completion(error)
            return
        }
        
        // Make a datatask
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check for errors
            if let error = error {
                NSLog("Error POSTing id token to Sleepsta: \(error)")
                completion(error)
                return
            }
            
            // Check if any data was returned
            guard let data = data else {
                NSLog("No data was returned")
                completion(NSError())
                return
            }
            
            print(String(data: data, encoding: .utf8) ?? "Couldn't turn data into String")
            
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data), let jsonDict = jsonObject as? [String: Any] else {
                NSLog("Wasn't able to serialize the data")
                completion(NSError())
                return
            }
            
            // Set the current user to a User made from the data returned from the network request
            User.current = User(jsonDict: jsonDict)
            
            if User.current != nil {
                completion(nil)
            } else {
                NSLog("Wasn't able to set the current user from jsonDict: \(jsonDict)")
                completion(NSError())
            }
            
        }.resume()
    }
    
    static func updateUserData() {
        guard let currentUser = User.current else { return }
        let requestURL = URL(string: .baseURLString)!.appendingPathComponent("users").appendingPathComponent("\(currentUser.sleepstaID)")
        
        var request = URLRequest(url: requestURL)
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue(currentUser.sleepstaToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            // If an error comes back, it means the token is expired, so log back in with Google
            if let error = error {
                print("Error GETting user info: \(error.localizedDescription)")
                if let bool = GIDSignIn.sharedInstance()?.hasAuthInKeychain(), bool {
                    GIDSignIn.sharedInstance()?.signInSilently()
                } else {
                    GIDSignIn.sharedInstance()?.disconnect()
                }
            }
            
            guard let data = data else {
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                if jsonObject is [String: Any] {
                    // There's a problem, the token isn't valid.
                    if GIDSignIn.sharedInstance()!.hasAuthInKeychain() {
                        DispatchQueue.main.async {
                            GIDSignIn.sharedInstance()?.signInSilently()
                        }
                    } else {
                        GIDSignIn.sharedInstance()?.disconnect()
                    }
                } else {
                    // TODO: Update any user info that has changed
                }
            } catch {
                NSLog("Error decoding data: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    static func removeUser() {
        let keychain = KeychainSwift()
        keychain.clear()
        UserDefaults.standard.removeObject(forKey: .userEmail)
        UserDefaults.standard.removeObject(forKey: .userFirstName)
        UserDefaults.standard.removeObject(forKey: .userLastName)
        LocalNotificationHelper.shared.cancelCurrentNotifications()
        User.current = nil
    }
    
    let sleepstaID: Int
    let firstName: String?
    let lastName: String?
    let email: String
    let sleepstaToken: String
    let accountType: String
    
    init(sleepstaID: Int, sleepstaToken: String, email: String, accountType: String, firstName: String? = nil, lastName: String? = nil) {
        self.sleepstaID = sleepstaID
        self.sleepstaToken = sleepstaToken
        self.email = email
        self.accountType = accountType
        self.firstName = firstName
        self.lastName = lastName
        
        let keychain = KeychainSwift()
        keychain.set(sleepstaToken, forKey: .sleepstaToken)
        keychain.set("\(sleepstaID)", forKey: .sleepstaID)
        keychain.set(accountType, forKey: .userAccountType)
        
        UserDefaults.standard.set(firstName, forKey: .userFirstName)
        UserDefaults.standard.set(lastName, forKey: .userLastName)
        UserDefaults.standard.set(email, forKey: .userEmail)
    }
    
    convenience init?(jsonDict: [String: Any]) {
        guard let user = jsonDict["user"] as? [String: Any],
            let firstName = user["f_name"] as? String,
            let lastName = user["l_name"] as? String,
            let sleepstaID = user["id"] as? Int,
            let email = user["email"] as? String,
            let accountType = user["account_type"] as? String,
            let sleepstaToken = jsonDict["token"] as? String else { return nil }
        
        self.init(sleepstaID: sleepstaID, sleepstaToken: sleepstaToken, email: email, accountType: accountType, firstName: firstName, lastName: lastName)
    }
    
}
