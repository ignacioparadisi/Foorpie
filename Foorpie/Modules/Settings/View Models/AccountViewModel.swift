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
    enum Section: Int, CaseIterable {
        case companies
        case logout
    }
    
    var didFetchCompanies: ((CompaniesListViewModel) -> Void)?
    @Published var isLoadingCompanies = false
    @Published var isLoggingOut = false
    var didLogout: ((Bool) -> Void)?
    
    var companyName: String {
        return UserDefaults.standard.company?.name ?? ""
    }
    
    func section(for indexPath: IndexPath) -> Section? {
        guard let section = Section(rawValue: indexPath.section) else { return nil }
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
