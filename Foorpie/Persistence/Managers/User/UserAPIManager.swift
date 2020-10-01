//
//  UserAPIManager.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/22/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import Combine

enum RequestError: Error {
    case invalidURL
}

class UserAPIManager: UserPersistenceManagerRepresentable {
    static var shared: UserAPIManager = UserAPIManager()
    
    func login(user: User, result: @escaping (Result<User, Error>) -> Void) {
        guard let url = URLManager.loginURL else { return result(.failure(RequestError.invalidURL)) }
        APIService.shared.makeRequest(url: url, method: .post, body: user) { (res: Result<User, Error>) in
            switch res {
            case .success(let user):
                UserDefaults.standard.setValue(user.token, forKey: "X-Auth-Token")
                if let company = user.company {
                    UserDefaults.standard.setValue(company.id, forKey: "selectedCompany")
                }
                result(.success(user))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    func getCompanies(result: @escaping (Result<[Company], Error>) -> Void) {
        guard let url = URLManager.companiesURL else { return result(.failure(RequestError.invalidURL)) }
        print(url)
        APIService.shared.makeRequest(url: url, method: .get, result: result)
    }
}
