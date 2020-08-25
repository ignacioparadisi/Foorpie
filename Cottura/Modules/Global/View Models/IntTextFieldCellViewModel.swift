//
//  IntTextFieldCellViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class IntTextFieldCellViewModel: FieldViewModel {
    var value: Int?
    
    init(title: String? = nil, placeholder: String? = nil, value: Int? = nil) {
        self.value = value
        super.init()
        self.type = .integer
        self.title = title
        self.placeholder = placeholder
        if let value = value {
            self.stringValue = String(describing: value)
        }
    }
}
