//
//  LoginManager.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

class LoginManager {
    
    private let baseURL = URL(string: .baseURLString)!
    private(set) var token: String = ""
    
    static let shared = LoginManager()
    
    func login(email: String = "", password: String = "", firstName: String = "", lastName: String = "",  with loginType: LoginType = .login, completion: @escaping () -> Void) {
        let requestURL = baseURL.appendingPathComponent(loginType.rawValue)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let userData: [String: Any]
        if loginType == .register {
            userData = [
                "email": email,
                "password": password,
                "f_name": firstName,
                "l_name": lastName,
                "account_type": "test"
            ]
        } else {
            userData = [
                "email": "iostest@example.com",
                "password": "password"
            ]
        }
        
        do {
//            let requestData = try JSONEncoder().encode(user)
            let requestData = try JSONSerialization.data(withJSONObject: userData)
            print(String(data: requestData, encoding: .utf8)!)
            request.httpBody = requestData
        } catch {
//            NSLog("Unable to encode user: \(user)\nWith error: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            }
            
            if let data = data {
                print(String(data: data, encoding: .utf8)!)
            }
            
            completion()
        }.resume()
        
    }
    
}

enum LoginType: String {
    case login
    case register
}
