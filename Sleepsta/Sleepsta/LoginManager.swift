//
//  LoginManager.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

class LoginManager {
    
    private let baseURL = URL(string: "https://sleepsta.herokuapp.com")!
    
    static let shared = LoginManager()
    
    func loginUser(username: String, password: String, completion: @escaping () -> Void) {
        
    }
    
    func registerUser(user: User, completion: @escaping () -> Void) {
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
            let requestData = try jsonEncoder.encode(user)
            request.httpBody = requestData
        } catch {
            NSLog("Unable to encode user: \(user)\nWith error: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let data = data {
                print(String(data: data, encoding: .utf8)!)
            }
        }.resume()
        
        
    }
    
}
