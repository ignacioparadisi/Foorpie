//
//  UserAPIManager.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/22/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import Combine

class UserAPIManager: UserPersistenceManagerRepresentable {
    static var shared: UserAPIManager = UserAPIManager()
    
    func login(user: User, result: @escaping (Result<User, Error>) -> Void) {
        guard let url = URLManager.loginURL else { return }
        APIService.shared.makeRequest(url: url, method: .post, body: user, result: result)
    }
}
