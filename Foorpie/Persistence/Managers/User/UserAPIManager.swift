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
        APIService.shared.makeRequest(url: url, method: .post, body: user) { (res: Result<LoginResponse, Error>) in
            switch res {
            case .success(let response):
                if UserDefaults.standard.user == nil {
                    if let company = response.company {
                        UserDefaults.standard.company = company
                    }
                } else if let user = UserDefaults.standard.user, user.id != response.user.id {
                    if let company = response.company {
                        UserDefaults.standard.company = company
                    }
                }
                UserDefaults.standard.user = response.user
                result(.success(response.user))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    func logout(result: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URLManager.logoutURL else { return result(.failure(RequestError.invalidURL)) }
        APIService.shared.makeRequest(url: url, method: .delete) {  (res: Result<SuccessResponse, Error>) in
            result(.success(true))
        }
    }
    
    func getCompanies(result: @escaping (Result<[Company], Error>) -> Void) {
        guard let url = URLManager.companiesURL else { return result(.failure(RequestError.invalidURL)) }
        APIService.shared.makeRequest(url: url, method: .get, result: result)
    }
    
    func createCompany(_ company: Company, result: @escaping (Result<Company, Error>) -> Void) {
        guard let url = URLManager.companiesURL else { return result(.failure(RequestError.invalidURL)) }
        APIService.shared.makeRequest(url: url, method: .post, body: company, result: result)
    }
}
