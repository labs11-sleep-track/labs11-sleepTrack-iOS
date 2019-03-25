//
//  LoginManager.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

class LoginManager {
    
    private let baseURL = URL(string: "https://sleepsta.herokuapp.com/api")!
    private(set) var token: String = ""
    
    static let shared = LoginManager()
    
    func login(_ user: User, with loginType: LoginType = .login, completion: @escaping () -> Void) {
        let requestURL = baseURL.appendingPathComponent(loginType.rawValue)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        do {
            let requestData = try JSONEncoder().encode(user)
            print(String(data: requestData, encoding: .utf8)!)
            request.httpBody = requestData
        } catch {
            NSLog("Unable to encode user: \(user)\nWith error: \(error)")
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
