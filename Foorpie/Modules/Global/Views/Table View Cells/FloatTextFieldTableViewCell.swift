//
//  FloatTextFieldTCell.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/20/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class FloatTextFieldTableViewCell: TextFieldTableViewCell {
    // MARK: Functions
    override func setup() {
        super.setup()
        textField.delegate = self
    }
    
    // Configure the cell with the viewModel's information
    /// - Parameter viewModel: View Model that holds the information and subscribe to changes..
    func configure(with viewModel: IntTextFieldCellViewModel) {
        super.configure(with: viewModel)
        textField.keyboardType = .decimalPad
    }
}

extension FloatTextFieldTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !(textField.text?.isEmpty ?? true) || !string.isEmpty {
            let text = (textField.text ?? "") + string
            return Double(text) != nil
        }
        return true
    }
}
