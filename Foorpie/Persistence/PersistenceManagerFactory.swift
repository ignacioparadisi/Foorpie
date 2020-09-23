//
//  PersistenceManagerFactory.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/20/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class PersistenceManagerFactory {
    
    static var menuPersistenceManager: MenuPersistenceManagerRepresentable {
        return MenuCoreDataManager.shared
    }
    
    static var userPersistenceManager: UserPersistenceManagerRepresentable {
        return UserAPIManager.shared
    }
    
}
