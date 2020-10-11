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
    var id: Int {
        return company.id
    }
    var name: String {
        return company.name
    }
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                UserDefaults.standard.company = company
            }
        }
    }
    init(company: Company) {
        self.company = company
        isSelected = UserDefaults.standard.company?.id == company.id
    }
    
    static func == (lhs: CompanyViewModel, rhs: CompanyViewModel) -> Bool {
        return lhs.company == rhs.company
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(company.id)
    }
    
//    func setSelected(_ value: String) {
//
//        isSelected = true
//    }
//
//    func setDeselected() {
//        isSelected = false
//    }
}
