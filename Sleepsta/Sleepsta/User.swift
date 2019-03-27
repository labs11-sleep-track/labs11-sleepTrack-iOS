//
//  User.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

class User: Codable {
    static var current: User? = nil
    
    // Signs the user in to Sleepsta and sets the current use to the result.
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
            User.current = User(jsonDict: jsonDict, idToken: idToken)
            
            if User.current != nil {
                completion(nil)
            } else {
                NSLog("Wasn't able to set the current user from jsonDict: \(jsonDict)")
                completion(NSError())
            }
            
        }.resume()
    }
    
    let sleepstaID: Int
    let firstName: String?
    let lastName: String?
    let email: String
    let idToken: String
    let sleepstaToken: String
    let accountType: String
    
    init(sleepstaID: Int, sleepstaToken: String, email: String, idToken: String, accountType: String, firstName: String? = nil, lastName: String? = nil) {
        self.sleepstaID = sleepstaID
        self.sleepstaToken = sleepstaToken
        self.email = email
        self.idToken = idToken
        self.accountType = accountType
        self.firstName = firstName
        self.lastName = lastName
    }
    
    convenience init?(jsonDict: [String: Any], idToken: String) {
        guard let user = jsonDict["user"] as? [String: Any],
            let firstName = user["f_name"] as? String,
            let lastName = user["l_name"] as? String,
            let sleepstaID = user["id"] as? Int,
            let email = user["email"] as? String,
            let accountType = user["account_type"] as? String,
            let sleepstaToken = jsonDict["token"] as? String else { return nil }
        
        self.init(sleepstaID: sleepstaID, sleepstaToken: sleepstaToken, email: email, idToken: idToken, accountType: accountType, firstName: firstName, lastName: lastName)
    }
    
}
