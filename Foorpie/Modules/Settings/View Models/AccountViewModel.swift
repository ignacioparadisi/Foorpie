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
    enum Section: Int {
        case information
        case logout
    }
    enum InformationRow: Int {
        case companies
        case users
    }
    
    var didFetchCompanies: ((CompaniesListViewModel?, Error?) -> Void)?
    var didFetchUsers: ((UsersListViewModel?, Error?) -> Void)?
    @Published private(set) var isLoadingCompanies = false
    @Published private(set) var isLoadingUsers = false
    @Published var isLoggingOut = false
    var didLogout: ((Bool) -> Void)?
    
    var companyName: String {
        return UserDefaults.standard.company?.name ?? ""
    }
    var informationRowsTitle: [String] {
        var rows = [LocalizedStrings.Title.company]
        if UserDefaults.standard.company?.ownerId == UserDefaults.standard.user?.id {
            rows.append(LocalizedStrings.Title.users)
        }
        return rows
    }
    
    func section(for indexPath: IndexPath) -> Section? {
        guard let section = Section(rawValue: indexPath.section) else { return nil }
        return section
    }
    
    func informationRow(for indexPath: IndexPath) -> InformationRow? {
        guard let section = section(for: indexPath), section == .information else { return nil }
        guard let row = InformationRow(rawValue: indexPath.row) else { return nil }
        return row
    }
    
    func fetchCompanies() {
        if isLoadingCompanies { return }
        isLoadingCompanies = true
        APIManagerFactory.companyAPIManager.getCompanies { [weak self] result in
            self?.isLoadingCompanies = false
            switch result {
            case .success(let companies):
                let viewModel = CompaniesListViewModel(companies: companies)
                self?.didFetchCompanies?(viewModel, nil)
            case .failure(let error):
                print(error)
                self?.didFetchCompanies?(nil, error)
            }
        }
    }
    
    func fetchUsers() {
        if isLoadingUsers { return }
        guard let companyId = UserDefaults.standard.company?.id else { return }
        isLoadingUsers = true
        APIManagerFactory.userAPIManager.fetchUsers(companyId: companyId) { [weak self] result in
            self?.isLoadingUsers = false
            switch result {
            case .success(let users):
                let viewModel = UsersListViewModel(users: users)
                self?.didFetchUsers?(viewModel, nil)
            case .failure(let error):
                print(error)
                self?.didFetchUsers?(nil, error)
            }
        }
    }
    
    func logout() {
        if isLoggingOut { return }
        isLoggingOut = true
        APIManagerFactory.userAPIManager.logout { [weak self] result in
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
