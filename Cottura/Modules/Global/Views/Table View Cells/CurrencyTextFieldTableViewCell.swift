//
//  CurrencyTextFieldTableViewCell.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

class CurrencyTextFieldTableViewCell: TextFieldTableViewCell {
    
    private var amount: Int = 0
    @Published var doubleValue: Double = 0.0
    private let numberFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    override func setup() {
        super.setup()
        textField.keyboardType = .numberPad
        textField.delegate = self
    }
    func configure(with viewModel: CurrencyTextFieldCellViewModel) {
        super.configure(with: viewModel)
        if viewModel.type == .currency {
            textFieldSubscription = $doubleValue
                .map { "\($0)" }
                .assign(to: \.stringValue, on: viewModel)
            if let value = viewModel.value {
                amount = Int(value * 100)
                textField.text = updateTextField()
            }
        }
    }
    private func updateTextField() -> String? {
        let number = Double(amount / 100) + Double(amount % 100) / 100
        doubleValue = number
        return numberFormatter.string(from: NSNumber(value: number))
    }
}

extension CurrencyTextFieldTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let digit = Int(string) {
            amount = amount * 10 + digit
            textField.text = updateTextField()
        }
        if string == "" {
            amount = amount / 10
            textField.text = updateTextField()
        }
        return false
    }
}
