//
//  APIValidationError.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/23/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class ServerError: Decodable {
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}

class APIValidationError: Decodable {
    var value: String?
    var message: String
    var param: String
    var location: String
    
    enum CodingKeys: String, CodingKey {
        case value
        case message = "msg"
        case param
        case location
    }
}
