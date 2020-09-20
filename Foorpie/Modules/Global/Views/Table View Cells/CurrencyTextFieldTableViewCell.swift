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
    // MARK: Properties
    /// Double representation of the textField's value
    @Published var doubleValue: Double = 0.0
    private let currencyTextField = CurrencyTextField()
    
    // MARK: Functions
    /// Setup view
    override func setup() {
        super.setup()
        textField.isUserInteractionEnabled = false
        textField.isHidden = true
        contentView.addSubview(currencyTextField)
        currencyTextField.anchor
            .top(to: textField.topAnchor)
            .leading(to: textField.leadingAnchor)
            .bottom(to: textField.bottomAnchor)
            .trailing(to: textField.trailingAnchor)
            .activate()
    }
    
    /// Configure the cell with the viewModel's information
    /// - Parameter viewModel: View Model that holds the information and subscribe to changes..
    func configure(with viewModel: CurrencyTextFieldCellViewModel) {
        super.configure(with: viewModel)
        if viewModel.type == .currency {
            textFieldSubscription = currencyTextField.$doubleValue
                .map { "\($0)" }
                .assign(to: \.stringValue, on: viewModel)
            currencyTextField.configure(with: viewModel.value)
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        currencyTextField.becomeFirstResponder()
        return super.becomeFirstResponder()
    }
    
}
