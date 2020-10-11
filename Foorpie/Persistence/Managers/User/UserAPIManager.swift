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
    case unknown
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
        guard let url = URLManager.companiesURL() else { return result(.failure(RequestError.invalidURL)) }
        APIService.shared.makeRequest(url: url, method: .get, result: result)
    }
    
    func createCompany(_ company: Company, result: @escaping (Result<Company, Error>) -> Void) {
        guard let url = URLManager.companiesURL() else { return result(.failure(RequestError.invalidURL)) }
        APIService.shared.makeRequest(url: url, method: .post, body: company, result: result)
    }
    
    func deleteCompany(_ id: Int, result: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URLManager.companiesURL(id: id) else { return result(.failure(RequestError.invalidURL)) }
        print(url)
        APIService.shared.makeRequest(url: url, method: .delete) { (res: Result<SuccessResponse, Error>) in
            switch res {
            case .success(let successResponse):
                if successResponse.success == true {
                    result(.success(true))
                } else {
                    result(.failure(RequestError.unknown))
                }
            case .failure(let error):
                result(.failure(error))
            }
            
        }
    }
}
