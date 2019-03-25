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
    
    var identifier: String
    var firstName: String?
    var lastName: String?
    var email: String
    var idToken: String
    
    init(identifier: String, email: String, idToken: String, firstName: String? = nil, lastName: String? = nil) {
        self.email = email
        self.idToken = idToken
        self.identifier = identifier
        self.firstName = firstName
        self.lastName = lastName
    }
    
}
