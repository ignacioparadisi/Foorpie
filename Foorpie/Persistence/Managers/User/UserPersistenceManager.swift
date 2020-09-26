//
//  UserPersistenceManager.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/22/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class User: Codable {
    var id: Int
    var fullName: String?
    var email: String
    var googleToken: String?
    var appleToken: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName
        case email
        case googleToken
        case appleToken
    }
    
    init(email: String, fullName: String? = nil, googleToken: String? = nil, appleToken: String? = nil) {
        self.id = 0
        self.fullName = fullName
        self.email = email
        self.googleToken = googleToken
        self.appleToken = appleToken
    }
}

protocol UserPersistenceManagerRepresentable {
    func login(user: User, result: @escaping (Result<User, Error>) -> Void)
}
