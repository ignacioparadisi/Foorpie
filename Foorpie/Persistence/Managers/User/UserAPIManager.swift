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
    case invalidBody
    case unknown
}

class UserAPIManager: UserAPIManagerRepresentable {
    static var shared: UserAPIManager = UserAPIManager()
    
    private init() {}
    
    func logout(result: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URLManager.logoutURL else { return result(.failure(RequestError.invalidURL)) }
        APIService.shared.makeRequest(url: url, method: .delete) {  (res: Result<SuccessResponse, Error>) in
            result(.success(true))
        }
    }
    
    func createInvitation(result: @escaping (Result<Invitation, Error>) -> Void) {
        guard let url = URLManager.invitationURL() else { return result(.failure(RequestError.invalidURL)) }
        guard let companyId = UserDefaults.standard.company?.id else { return result(.failure(RequestError.invalidBody)) }
        let invitation = Invitation(companyId: companyId)
        APIService.shared.makeRequest(url: url, method: .post, body: invitation, result: result)
    }
    
    func acceptInvitation(invitation: Invitation, result: @escaping (Result<Company, Error>) -> Void) {
        guard let url = URLManager.acceptInvitationURL else { return result(.failure(RequestError.invalidURL)) }
        APIService.shared.makeRequest(url: url, method: .post, body: invitation, result: result)
    }
}

// MARK: - GET
extension UserAPIManager {
    func fetchInvitationInformation(token: String, result: @escaping (Result<Invitation, Error>) -> Void) {
        guard let url = URLManager.invitationURL(token: token) else { return result(.failure(RequestError.invalidURL)) }
        APIService.shared.makeRequest(url: url, method: .get, result: result)
    }
    
    func fetchUsers(companyId: Int, result: @escaping (Result<[User], Error>) -> Void) {
        guard let url = URLManager.usersURL(companyId: companyId) else { return result(.failure(RequestError.invalidURL)) }
        APIService.shared.makeRequest(url: url, method: .get, result: result)
    }
}

// MARK: - POST
extension UserAPIManager {
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
}
