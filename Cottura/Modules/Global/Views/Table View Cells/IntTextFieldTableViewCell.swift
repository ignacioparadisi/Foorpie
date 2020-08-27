//
//  IntTextFieldTableViewCell.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class IntTextFieldTableViewCell: TextFieldTableViewCell {
    
    private let stepper = UIStepper()
    
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
    
    func configure(with viewModel: IntTextFieldCellViewModel) {
        super.configure(with: viewModel)
        textField.keyboardType = .numberPad
        stepper.value = viewModel.stringValue?.doubleValue ?? 0
    }
    
    @objc private func stepperValueChanged(_ stepper: UIStepper) {
        let value = Int(stepper.value)
        textField.text = "\(value)"
    }
    
    @objc private func textFieldValueChanged(_ textField: UITextField) {
        if let text = textField.text, let value = Double(text) {
            stepper.value = value
        } else {
            stepper.value = 0
        }
        
    }
}
