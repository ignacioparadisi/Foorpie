//
//  CompanyViewModel.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/10/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class CompanyViewModel: Hashable {
    
    private let company: Company
    var name: String {
        return company.name
    }
    var isSelected: Bool {
        return UserDefaults.standard.getSelectedCompany()?.id == company.id
    }
    init(company: Company) {
        self.company = company
    }
    
    static func == (lhs: CompanyViewModel, rhs: CompanyViewModel) -> Bool {
        return lhs.company == rhs.company
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(company.id)
    }
}
