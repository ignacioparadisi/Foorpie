//
//  UserPersistenceManager.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/22/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol UserAPIManagerRepresentable {
    func login(user: User, result: @escaping (Result<User, Error>) -> Void)
    func logout(result: @escaping (Result<Bool, Error>) -> Void)
    func fetchUsers(companyId: Int, result: @escaping (Result<[User], Error>) -> Void)
    func createInvitation(result: @escaping (Result<Invitation, Error>) -> Void)
    func acceptInvitation(invitation: Invitation, result: @escaping (Result<Company, Error>) -> Void)
    func fetchInvitationInformation(token: String, result: @escaping (Result<Invitation, Error>) -> Void)
}
