//
//  CompaniesListViewModel.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/3/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class CompaniesListViewModel {
    
    enum Section: Int {
        case companies
    }
    
    @Published var isLoading = false
    var didSaveCompany: ((Bool) -> Void)?
    var didDeleteCompany: (() -> Void)?
    var canEdit: Bool {
        return companies.count > 1
    }
    var numberOfRows: Int {
        return companies.count
    }
    var companies: [CompanyViewModel] = []
    
    init(companies: [Company] = []) {
        self.companies = companies.map { CompanyViewModel(company: $0) }
    }
    
    func canEditRow(at indexPath: IndexPath) -> Bool {
        let company = companies[indexPath.row]
        return company.id != UserDefaults.standard.company?.id && canEdit
    }
    
    func saveCompany(named name: String) {
        if isLoading { return }
        self.isLoading = true
        let company = Company(name: name)
        UserAPIManager.shared.createCompany(company) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let company):
                self?.companies.append(CompanyViewModel(company: company))
                self?.companies.sort { company1, company2 in
                    return company1.name < company2.name
                }
                self?.didSaveCompany?(true)
            case .failure(let error):
                print(error.localizedDescription)
                self?.didSaveCompany?(false)
            }
        }
    }
    
    func selectCompany(at indexPath: IndexPath) {
        let selectedCompany = UserDefaults.standard.company
        let previouslySelected = companies.filter { $0.id == selectedCompany?.id }.first
        previouslySelected?.isSelected = false
        let company = companies[indexPath.row]
        company.isSelected = true
    }
    
    func deleteCompany(at indexPath: IndexPath) {
        let company = companies[indexPath.row]
        companies.remove(at: indexPath.row)
        didDeleteCompany?()
    }
    
}
