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
    
    private var companies: [Company] = []
    var canEdit: Bool {
        return companies.count > 1
    }
    var numberOfRows: Int {
        return companies.count
    }
    
    init(companies: [Company] = []) {
        self.companies = companies
    }
    
    func companyForRow(at indexPath: IndexPath) -> Company {
        return companies[indexPath.row]
    }
    
    var companiesViewModels: [CompanyViewModel] {
        return companies.map { CompanyViewModel(company: $0) }
    }
}
