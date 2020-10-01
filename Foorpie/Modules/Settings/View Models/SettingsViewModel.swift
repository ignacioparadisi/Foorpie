//
//  SettingsViewModel.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/1/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import Combine

class SettingsViewModel {
    enum Sections: Int, CaseIterable {
        case companies
        case logout
    }
    
    var didFetchCompanies: (([Company]) -> Void)?
    @Published var isLoadingCompanies = false
    
    var numberOfSections: Int {
        return Sections.allCases.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let section = Sections(rawValue: section) else { return 0 }
        switch section {
        case .companies:
            return 1
        case .logout:
            return 1
        default:
            return 0
        }
    }
    
    func section(for indexPath: IndexPath) -> Sections? {
        guard let section = Sections(rawValue: indexPath.section) else { return nil }
        return section
    }
    
    func fetchCompanies() {
        self.isLoadingCompanies = true
        if isLoadingCompanies { return }
        isLoadingCompanies = true
        UserAPIManager.shared.getCompanies { [weak self] result in
            self?.isLoadingCompanies = false
            switch result {
            case .success(let companies):
                self?.didFetchCompanies?(companies)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func logout() {
        
    }
}
