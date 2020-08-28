//
//  NoItemSelectedViewController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/26/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class NoItemSelectedViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3).bold
        label.textAlignment = .center
        return label
    }()
    /// Detail label for the view
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    static var menuDishController = NoItemSelectedViewController(title: "No tienes ningún plato seleccionado", message: "Por favor selecciona un plato para ver el detalle.")
    
    init(title: String, message: String) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title
        detailLabel.text = message
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(detailLabel)
        
        titleLabel.anchor
            .trailingToSuperview(constant: -20, toSafeArea: true)
            .bottom(to: view.centerYAnchor, constant: -5)
            .leadingToSuperview(constant: 20, toSafeArea: true)
            .centerXToSuperview()
            .activate()
        
        detailLabel.anchor
            .top(to: view.centerYAnchor, constant: 5)
            .trailingToSuperview(constant: -20, toSafeArea: true)
            .leadingToSuperview(constant: 20, toSafeArea: true)
            .centerXToSuperview()
            .activate()
    }
    
}
