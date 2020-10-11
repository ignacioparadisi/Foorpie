//
//  UserDefaults+Extension.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/2/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

extension UserDefaults {
    var user: User? {
        get {
            let userData = data(forKey: "loggedUser")
            if let userData = userData {
                return try? APIService.shared.decode(User.self, from: userData)
            }
            return nil
        }
        set {
            let userData = try? APIService.shared.encode(newValue)
            if let data = userData {
                setValue(data, forKey: "loggedUser")
            }
        }
    }
    
    var company: Company? {
        get {
            let companyData = data(forKey: "selectedCompany")
            if let companyData = companyData {
                return try? APIService.shared.decode(Company.self, from: companyData)
            }
            return nil
        }
        set {
            let companyData = try? APIService.shared.encode(newValue)
            if let data = companyData {
                setValue(data, forKey: "selectedCompany")
                companyName = newValue?.name ?? ""
            }
        }
    }
    
    
    @objc dynamic var companyName: String {
        get {
            return string(forKey: "selectedCompanyName") ?? ""
        }
        set {
            setValue(newValue, forKey: "selectedCompanyName")
        }
    }
}
