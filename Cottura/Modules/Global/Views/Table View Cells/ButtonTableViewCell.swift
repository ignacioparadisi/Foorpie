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
    }
    
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
    /// Setup view
    private func setup() {
        textLabel?.textAlignment = .center
    }
    /// Configure the cell with a title and a style
    /// - Parameters:
    ///   - title: Title for the cell
    ///   - style: Style of the cell
    func configure(with title: String, style: ButtonTableViewCell.Style) {
        textLabel?.text = title
        switch style {
        case .default:
            textLabel?.textColor = .systemBlue
        case .destructive:
            textLabel?.textColor = .systemRed
        }
    }
}
