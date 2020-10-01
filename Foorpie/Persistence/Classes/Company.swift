//
//  Company.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/1/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class Company: Codable {
    var id: Int
    var name: String
    var isOwner: Bool
    var userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isOwner
        case userId
    }
    
    init(name: String) {
        self.id = 0
        self.isOwner = true
        self.userId = 0
        self.name = name
    }
}
