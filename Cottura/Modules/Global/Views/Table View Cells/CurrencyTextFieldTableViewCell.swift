//
//  CurrencyTextFieldTableViewCell.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class CurrencyTextFieldTableViewCell: TextFieldTableViewCell {
    
    func configure(with viewModel: CurrencyTextFieldCellViewModel) {
        super.configure(with: viewModel)
        if viewModel.type == .currency {
            textFieldSubscription = textField.publisher(for: \.text)
                .map {
                    guard let value = $0 else { return nil }
                    return "\(value.currencyDoubleValue)"
                }
                .replaceNil(with: "0.00")
                .assign(to: \.stringValue, on: viewModel)
            textField.text = String(format: "%.2f", viewModel.stringValue?.currencyDoubleValue ?? 0)
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            textFieldDidChange(textField)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
}

extension String {

    // formatting text for currency textField
    func currencyInputFormatting() -> String {

        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2

//        var amountWithPrefix = self
//
//        // remove from String: "$", ".", ","
//        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
//        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
//
//        let double = (amountWithPrefix as NSString).doubleValue
//        print(double)
//        number = NSNumber(value: (double / 100))
        number = NSNumber(value: currencyDoubleValue)

        return formatter.string(from: number)!
    }
    
    var currencyDoubleValue: Double {
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        let value = regex.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        if let doubleValue = Double(value) {
            return doubleValue / 100
        } else {
            return 0.00
        }
    }
}
