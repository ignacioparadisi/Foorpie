//
//  UserDefaults+Extension.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/2/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

extension UserDefaults {
    func setToken(_ token: String) {
        UserDefaults.standard.setValue(token, forKey: "X-Auth-Token")
    }
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: "X-Auth-Token")
    }
    func setSelectedCompany(_ companyId: Int) {
        UserDefaults.standard.setValue(companyId, forKey: "selectedCompany")
    }
    func getSelectedCompany() -> Int? {
        UserDefaults.standard.integer(forKey: "selectedCompany")
    }
}
