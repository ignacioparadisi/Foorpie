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
    private let textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
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
    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        
        titleLabel.anchor
            .topToSuperview(constant: verticalMargin)
            .trailingToSuperview(constant: -horizontalMargin)
            .leadingToSuperview(constant: horizontalMargin)
            .activate()
        
        textField.anchor
            .top(to: titleLabel.bottomAnchor, constant: 5)
            .trailingToSuperview(constant: -horizontalMargin)
            .bottomToSuperview(constant: -verticalMargin)
            .leadingToSuperview(constant: horizontalMargin)
            .activate()
    }
    
    func configure(with title: String, value: String) {
        titleLabel.text = title
        textField.text = value
    }
    
    func configure(with viewModel: TextFieldCellViewModel) {
        titleLabel.text = viewModel.title
        textField.placeholder = viewModel.placeholder
        textField.text = viewModel.stringValue
    }
}
