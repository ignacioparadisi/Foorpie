//
//  Invitation.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/11/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class Invitation: Codable {
    let urlString: String
    let companyId: Int?
    
    init(companyId: Int) {
        self.urlString = ""
        self.companyId = companyId
    }
    
    enum CodingKeys: String, CodingKey {
        case urlString = "url"
        case companyId = "company_id"
    }
}
