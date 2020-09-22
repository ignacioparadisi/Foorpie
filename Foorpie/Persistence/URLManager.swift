//
//  URLManager.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/22/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

enum Environment {
    case local
    case production
    case development
}

var environment: Environment {
    #if LOCAL
    return .local
    #elseif DEVELOPMENT
    return .development
    #else
    return .production
    #endif
}
