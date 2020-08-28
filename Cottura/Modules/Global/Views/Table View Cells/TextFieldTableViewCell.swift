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
    /// Vertical margin for the content of the cell
    private let verticalMargin: CGFloat = 8
    /// Horizontal margin for the content of the cell
    private let horizontalMargin: CGFloat = 16
    /// Label for displaying the title of the field
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1).bold
        label.textColor = .secondaryLabel
        return label
    }()
    /// Textfield for input the data.
    let textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    /// Label for displaying the error of the field.
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .systemRed
        return label
    }()
    /// Subscription to the textField for getting it's value when it changes
    var textFieldSubscription: AnyCancellable?
    /// Subscription for getting the validation when it changes
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
    /// Add all subviews into the view
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
    
    /// Configures all views with the information stored in the view model
    /// - Parameter viewModel: View Model that holds the information and receives the changes.
    func configure(with viewModel: FieldViewModel) {
        titleLabel.text = viewModel.title?.uppercased()
        if let text = titleLabel.text, viewModel.validations.contains(.required) {
            titleLabel.text = "\(text) *"
        }
        textField.placeholder = viewModel.placeholder
        textField.text = viewModel.stringValue
        textFieldSubscription = textField.publisher(for: \.text)
            .assign(to: \.stringValue, on: viewModel)
        validationSubscription = viewModel.$isValid.sink { [weak self] isValid in
            self?.titleLabel.textColor = isValid ? .systemBlue : .secondaryLabel
        }
    }
    
    /// Make textfield become first responder when the cell becomes first responder.
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
        return true
    }
}
