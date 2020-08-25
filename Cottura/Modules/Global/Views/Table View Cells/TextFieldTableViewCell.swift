//
//  TextFieldTableViewCell.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell, ReusableView {
    // MARK: Properties
    private let verticalMargin: CGFloat = 8
    private let horizontalMargin: CGFloat = 16
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1).bold
        label.textColor = .secondaryLabel
        return label
    }()
    let textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .systemRed
        return label
    }()
    var viewModel: FieldViewModelRepresentable!
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: Functions
   func setup() {
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        contentView.addSubview(errorLabel)
        
        titleLabel.anchor
            .topToSuperview(constant: verticalMargin)
            .trailingToSuperview(constant: -horizontalMargin)
            .leadingToSuperview(constant: horizontalMargin)
            .activate()
        
        textField.anchor
            .top(to: titleLabel.bottomAnchor, constant: 5)
            .trailingToSuperview(constant: -horizontalMargin)
            .leadingToSuperview(constant: horizontalMargin)
            .activate()
    
        errorLabel.anchor
            .top(to: textField.bottomAnchor, constant: 2)
            .trailingToSuperview(constant: -horizontalMargin)
            .bottomToSuperview(constant: -6)
            .leadingToSuperview(constant: horizontalMargin)
            .activate()
    }
    
    func configure(with viewModel: FieldViewModelRepresentable) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title?.uppercased()
        textField.placeholder = viewModel.placeholder
        textField.text = viewModel.stringValue
        if viewModel.type == .currency {
            let field = viewModel as! CurrencyTextFieldCellViewModel
            textField.text = String(format: "%.2f", field.value)
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            textFieldDidChange(textField)
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
        return true
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

        var amountWithPrefix = self
//        let splitString = amountWithPrefix.split(separator: ".")
//        if splitString.count > 1 && splitString[1].count < 2 {
//            amountWithPrefix += "0"
//        }

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        print(double)
        number = NSNumber(value: (double / 100))

        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return formatter.string(from: 0)!
        }

        return formatter.string(from: number)!
    }
}
