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
}

protocol FieldViewModel {
    var placeholder: String? { get set }
    var stringValue: String? { get set }
    var title: String? { get set }
    var type: FieldType { get }
}
