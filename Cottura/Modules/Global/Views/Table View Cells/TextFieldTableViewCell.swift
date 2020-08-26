//
//  TextFieldTableViewCell.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

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
    var textFieldSubscription: AnyCancellable?
    private var validationSubscription: AnyCancellable?
    
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
    
    func configure(with viewModel: FieldViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title?.uppercased()
        textField.placeholder = viewModel.placeholder
        textField.text = viewModel.stringValue
        textFieldSubscription = textField.publisher(for: \.text)
            .assign(to: \.stringValue, on: viewModel)
        validationSubscription = viewModel.$isValid.sink { [weak self] isValid in
            self?.titleLabel.textColor = isValid ? .systemBlue : .secondaryLabel
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
        return true
    }
}
