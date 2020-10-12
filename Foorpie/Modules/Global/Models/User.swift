//
//  User.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/1/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class UserViewModel: Hashable {
    private let user: User
    var fullName: String {
        var name = user.fullName ?? ""
        if isMe {
            name += " (Me)"
        }
        return name
    }
    var isMe: Bool {
        return UserDefaults.standard.user?.id == user.id
    }
    
    init(user: User) {
        self.user = user
    }
    
    static func == (lhs: UserViewModel, rhs: UserViewModel) -> Bool {
        return lhs.user == rhs.user
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(user.id)
    }
    
}

class User: Codable, Equatable {
    var id: Int
    var fullName: String?
    var email: String?
    var googleToken: String?
    var appleToken: String?
    var token: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
        case googleToken = "google_token"
        case appleToken = "apple_token"
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
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
