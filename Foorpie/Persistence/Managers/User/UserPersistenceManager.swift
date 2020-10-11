//
//  UserPersistenceManager.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/22/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol UserPersistenceManagerRepresentable {
    func login(user: User, result: @escaping (Result<User, Error>) -> Void)
    func logout(result: @escaping (Result<Bool, Error>) -> Void)
    func getCompanies(result: @escaping (Result<[Company], Error>) -> Void)
    func createCompany(_ company: Company, result: @escaping (Result<Company, Error>) -> Void)
}
