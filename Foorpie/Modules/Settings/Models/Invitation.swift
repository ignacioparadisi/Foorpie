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
    let token: String?
    let company: Company?
    
    init(companyId: Int = -1, token: String = "") {
        self.company = nil
        self.urlString = ""
        self.token = token
        self.companyId = companyId
    }
    
    enum CodingKeys: String, CodingKey {
        case urlString = "url"
        case companyId = "company_id"
        case company
        case token
    }
}
