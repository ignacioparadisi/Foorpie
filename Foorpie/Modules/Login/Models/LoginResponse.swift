//
//  LoginResponse.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/3/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class LoginResponse: Decodable {
    var user: User
    var company: Company?
    
    enum CodingKeys: String, CodingKey {
        case user, company
    }
}
