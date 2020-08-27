//
//  ButtonTableViewCell.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit



class ButtonTableViewCell: UITableViewCell, ReusableView {
    enum Style {
        case `default`
        case destructive
    }
    let button = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
//        contentView.addSubview(button)
//        button.anchor
//            .edgesToSuperview()
//            .height(constant: 44)
//            .activate()
        textLabel?.textAlignment = .center
    }
    func configure(with title: String, style: ButtonTableViewCell.Style) {
        textLabel?.text = title
        textLabel?.textColor = .systemRed
//        button.setTitle(title, for: .normal)
//        switch style {
//        case .default:
//            button.setTitleColor(.systemBlue, for: .normal)
//        case .destructive:
//            button.setTitleColor(.systemRed, for: .normal)
//        }
    }
}
