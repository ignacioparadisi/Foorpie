//
//  SuccessResponse.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/2/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class SuccessResponse: Decodable {
    var success: Bool
    
    enum CodingKeys: String, CodingKey {
        case success
    }
}
