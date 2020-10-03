//
//  UserDefaults+Extension.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/2/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

extension UserDefaults {
    func setUser(_ user: User) {
        let userData = try? APIService.shared.encode(user)
        if let data = userData {
            UserDefaults.standard.setValue(data, forKey: "loggedUser")
        }
    }
    func getUser() -> User? {
        let data = UserDefaults.standard.data(forKey: "loggedUser")
        if let userData = data {
            return try? APIService.shared.decode(User.self, from: userData)
        }
        return nil
    }
    func setSelectedCompany(_ company: Company) {
        let companyData = try? APIService.shared.encode(company)
        if let data = companyData {
            UserDefaults.standard.setValue(data, forKey: "selectedCompany")
        }
    }
    func getSelectedCompany() -> Company? {
        let data = UserDefaults.standard.data(forKey: "selectedCompany")
        if let companyData = data {
            return try? APIService.shared.decode(Company.self, from: companyData)
        }
        return nil
    }
}
