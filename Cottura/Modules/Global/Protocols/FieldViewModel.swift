//
//  FieldViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

enum FieldType {
    case textField
    case currency
    case integer
}

protocol FieldViewModelRepresentable {
    var placeholder: String? { get set }
    var stringValue: String? { get }
    var title: String? { get set }
    var type: FieldType { get }
}
