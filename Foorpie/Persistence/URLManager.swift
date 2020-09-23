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

class URLManager {
    static private var baseURL: URL? {
        switch environment {
        case .local:
            return URL(string: "http://10.0.0.7:3000")
        default:
            return URL(string: "https://foorpie-dev.herokuapp.com")
        }
    }
    
    static var loginURL: URL? {
        return baseURL?.appendingPathComponent("login")
    }
}
