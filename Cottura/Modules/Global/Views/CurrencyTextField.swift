//
//  CurrencyTextField.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class CurrencyTextField: UITextField {
    @Published var doubleValue: Double = 0.0
    private var amount: Int = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        keyboardType = .numberPad
        delegate = self
    }
    /// Number Formatter to convert number into currency.
    private let numberFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with value: Double?) {
        if let value = value {
            amount = Int(value * 100)
            text = updateTextField()
        }
    }
    
    /// Updates the text field with the `amount` with currency format
    /// - Returns: Currency format of `amount` number.
    private func updateTextField() -> String? {
        let number = Double(amount / 100) + Double(amount % 100) / 100
        doubleValue = number
        return numberFormatter.string(from: NSNumber(value: number))
    }
}

extension CurrencyTextField: UITextFieldDelegate {
    /// Convert text field text into currency format each time the user enters a value.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let digit = Int(string) {
            amount = amount * 10 + digit
            text = updateTextField()
        }
        if string == "" {
            amount = amount / 10
            text = updateTextField()
        }
        return false
    }
}
