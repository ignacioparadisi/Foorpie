//
//  IntTextFieldTableViewCell.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class IntTextFieldTableViewCell: TextFieldTableViewCell {
    // MARK: Properties
    /// Stepper for changing the value displayed in the text field
    private let stepper = UIStepper()
    
    // MARK: Functions
    override func setup() {
        super.setup()
        stepper.minimumValue = 0
        addSubview(stepper)
        stepper.anchor
            .centerYToSuperview()
            .trailingToSuperview(constant: -16)
            .activate()
        
        textField.anchor
            .trailing(to: stepper.leadingAnchor)
            .activate()
        
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingDidEnd)
    }
    
    // Configure the cell with the viewModel's information
    /// - Parameter viewModel: View Model that holds the information and subscribe to changes..
    func configure(with viewModel: IntTextFieldCellViewModel) {
        super.configure(with: viewModel)
        textField.keyboardType = .numberPad
        stepper.value = viewModel.stringValue?.doubleValue ?? 0
    }
    
    /// Function called each time the value of the stepper changes for updating the value displayed in the textField.
    /// - Parameter stepper: Stepper that changed.
    @objc private func stepperValueChanged(_ stepper: UIStepper) {
        let value = Int(stepper.value)
        textField.text = "\(value)"
    }
    
    /// Function called each time the textfield editing ends for updating the value of the stepper with the value entered in the text field.
    /// - Parameter textField: Text field that changed.
    @objc private func textFieldValueChanged(_ textField: UITextField) {
        if let text = textField.text, let value = Double(text) {
            stepper.value = value
        } else {
            stepper.value = 0
        }
        
    }
}
