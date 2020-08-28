//
//  AlertView.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class AlertView: UIView {
    // MARK: Properties
    /// Style for the alert
    /// - Cases::
    ///     - success:  Show a green `checkmark.circle` image
    ///     - error: Shows a red ` xmark.circle` image
    ///     - none: Show no image
    enum Style {
        case success
        case error
        case none
    }
    /// Margin for the content inside the alert
    private let contentMargin: CGFloat = 30
    /// Title label for the alert
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3).bold
        label.textColor = .systemDarkGray
        label.textAlignment = .center
        return label
    }()
    /// Description label for the alert
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemDarkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    /// Image for to display the style of the alert
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: Initializers
    init(title: String?, message: String?, style: Style = .none) {
        super.init(frame: .zero)
        setup(title: title, message: message, style: style)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: Functions
    /// Sets the information for the view
    /// - Parameters:
    ///   - title: Title to be displayed in the alert.
    ///   - message: Message to be displayed as the description.
    ///   - style: Style to be applied to the alert
    private func setup(title: String? = nil, message: String? = nil, style: Style = .none) {
        layer.cornerRadius = 15
        clipsToBounds = true
        let blurEffect = UIBlurEffect(style: .systemThickMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        imageView.anchor
            .topToSuperview(constant: contentMargin)
            .leading(greaterOrEqual: leadingAnchor, constant: contentMargin)
            .trailing(greaterOrEqual: trailingAnchor, constant: -contentMargin)
            .centerXToSuperview()
            .width(constant: 100)
            .height(to: imageView.widthAnchor)
            .activate()
        titleLabel.anchor
            .top(to: imageView.bottomAnchor, constant: 10)
            .leadingToSuperview(constant: contentMargin)
            .trailingToSuperview(constant: -contentMargin)
            .activate()
        descriptionLabel.anchor
            .top(to: titleLabel.bottomAnchor, constant: 5)
            .leadingToSuperview(constant: contentMargin)
            .trailingToSuperview(constant: -contentMargin)
            .bottomToSuperview(constant: -contentMargin)
            .activate()
        
        titleLabel.text = title
        descriptionLabel.text = message
        
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 100, weight: .medium)
        switch style {
        case .none:
            imageView.image = nil
            imageView.anchor.height(constant: 0).activate()
        case .success:
            imageView.image = UIImage(systemName: "checkmark.circle", withConfiguration: symbolConfiguration)
            imageView.tintColor = .systemGreen
        case .error:
            imageView.image = UIImage(systemName: "xmark.circle", withConfiguration: symbolConfiguration)
            imageView.tintColor = .systemRed
        }
    }
}
