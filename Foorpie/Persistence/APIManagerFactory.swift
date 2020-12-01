//
//  APIManagerFactory.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/20/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class APIManagerFactory {
    
    static var menuPersistenceManager: MenuPersistenceManagerRepresentable {
        return MenuCoreDataManager.shared
    }
    
    static var userAPIManager: UserAPIManagerRepresentable {
        return UserAPIManager.shared
    }
    
    static var companyAPIManager: CompanyAPIManagerRepresentable {
        return CompanyAPIManager.shared
    }
    
}
