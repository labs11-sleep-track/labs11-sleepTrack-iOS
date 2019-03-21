//
//  User.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

class User: Codable {
    var firstName: String?
    var lastName: String?
    var email: String
    var password: String?
    
    init(email: String, password: String, firstName: String? = nil, lastName: String? = nil) {
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
    }
    
    enum CodingKeys: String, CodingKey {
        case firstName = "f_name"
        case lastName = "l_name"
        case email
        case password
    }
}
