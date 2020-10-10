//
//  Company.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/1/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class Company: Codable, Equatable {
    
    /// Identifier for the company
    var id: Int
    /// Name fo the company
    var name: String
    /// Identifier of the owner of the company
    var ownerId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case ownerId = "owner_id"
    }
    
    init(name: String) {
        self.id = 0
        self.ownerId = 0
        self.name = name
    }
    
    static func == (lhs: Company, rhs: Company) -> Bool {
        return lhs.id == rhs.id
    }
    
}
