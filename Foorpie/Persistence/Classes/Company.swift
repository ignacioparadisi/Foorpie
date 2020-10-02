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
    var ownerId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case ownerId = "onwer_id"
    }
    
    init(name: String) {
        self.id = 0
        self.ownerId = 0
        self.name = name
    }
}
