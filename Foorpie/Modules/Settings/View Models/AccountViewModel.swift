//
//  SettingsViewModel.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/1/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import Combine
import GoogleSignIn

class AccountViewModel {
    enum Sections: Int, CaseIterable {
        case companies
        case logout
    }
    
    var didFetchCompanies: ((CompaniesListViewModel) -> Void)?
    @Published var isLoadingCompanies = false
    @Published var isLoggingOut = false
    var didLogout: ((Bool) -> Void)?
    
    var numberOfSections: Int {
        return Sections.allCases.count
    }
    var companyName: String {
        return UserDefaults.standard.getSelectedCompany()?.name ?? ""
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
        if isLoadingCompanies { return }
        isLoadingCompanies = true
        UserAPIManager.shared.getCompanies { [weak self] result in
            self?.isLoadingCompanies = false
            switch result {
            case .success(let companies):
                let viewModel = CompaniesListViewModel(companies: companies)
                self?.didFetchCompanies?(viewModel)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func logout() {
        if isLoggingOut { return }
        isLoggingOut = true
        UserAPIManager.shared.logout { [weak self] result in
            self?.isLoggingOut = false
            switch result {
            case .success:
                GIDSignIn.sharedInstance()?.signOut()
                self?.didLogout?(true)
            case .failure:
                self?.didLogout?(false)
            }
        }
    }
}
