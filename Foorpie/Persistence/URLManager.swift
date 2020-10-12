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
    case staging
}

var environment: Environment {
    #if LOCAL
    return .local
    #elseif STAGING
    return .staging
    #else
    return .production
    #endif
}

class URLManager {
    static private var baseURL: URL? {
        switch environment {
        case .local:
            return URL(string: "http://192.168.1.3:3000/api")
        case .staging:
            return URL(string: "https://foorpie-dev.herokuapp.com/api")
        case .production:
            return URL(string: "https://foorpie.herokuapp.com/api")
        }
    }
    
    static var loginURL: URL? {
        return baseURL?.appendingPathComponent("login")
    }
    
    static var logoutURL: URL? {
        return baseURL?.appendingPathComponent("logout")
    }
    
    static var acceptInvitationURL: URL? {
        return baseURL?.appendingPathComponent("invitations/accept")
    }
    
    static func invitationURL(token: String? = nil) -> URL? {
        var url = baseURL?.appendingPathComponent("invitations")
        if let token = token {
            url = url?.appendingPathComponent(token)
        }
        return url
    }
    
    static func companiesURL(id: Int? = nil) -> URL? {
        var url = baseURL?.appendingPathComponent("companies")
        if let id = id {
            url = url?.appendingPathComponent("\(id)")
        }
        return url
    }
    
    static func usersURL(companyId: Int) -> URL? {
        return baseURL?.appendingPathComponent("users")
            .appendingQueryItem("company_id", value: "\(companyId)")
    }
}
