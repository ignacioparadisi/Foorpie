//
//  ButtonTableViewCell.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit



class ButtonTableViewCell: UITableViewCell, ReusableView {
    // MARK: Properties
    /// Style of the cell
    /// - Cases:
    ///     - default: The cell has a textColor of accent color
    ///     - destructive: The cell has a textColor of red
    enum Style {
        case `default`
        case destructive
        case filled
    }
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // preservesSuperviewLayoutMargins = false
        // layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets.zero
    }
    
    /// Configure the cell with a title and a style
    /// - Parameters:
    ///   - title: Title for the cell
    ///   - image: Image to be shown in the imageView
    ///   - style: Style of the cell
    ///   - alignment: Alignment for the text
    func configure(with title: String, image: UIImage? = nil, style: ButtonTableViewCell.Style, alignment: NSTextAlignment = .center) {
        textLabel?.text = title
        textLabel?.textAlignment = alignment
        imageView?.image = image
        switch style {
        case .default:
            textLabel?.textColor = .systemBlue
            imageView?.tintColor = .systemBlue
        case .destructive:
            textLabel?.textColor = .systemRed
            imageView?.tintColor = .systemRed
        case .filled:
            selectionStyle = .none
            textLabel?.textColor = .white
            imageView?.tintColor = .white
            backgroundColor = .systemBlue
        }
    }
}
