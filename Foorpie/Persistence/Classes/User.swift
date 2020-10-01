//
//  User.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/1/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class User: Codable {
    var id: Int
    var fullName: String?
    var email: String
    var googleToken: String?
    var appleToken: String?
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName
        case email
        case googleToken
        case appleToken
        case token
    }
    
    init(email: String, fullName: String? = nil, googleToken: String? = nil, appleToken: String? = nil) {
        self.id = 0
        self.fullName = fullName
        self.email = email
        self.googleToken = googleToken
        self.appleToken = appleToken
        self.token = ""
    }
}
