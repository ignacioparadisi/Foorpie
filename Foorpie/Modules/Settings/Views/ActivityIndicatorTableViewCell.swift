//
//  ActivityIndicatorTableViewCell.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/1/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class ActivityIndicatorTableViewCell: UITableViewCell, ReusableView {
    
    private let activityIndicator = UIActivityIndicatorView()
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.accessoryType = .disclosureIndicator
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
    }
    
    func startAnimating() {
        self.accessoryType = .none
        self.accessoryView = activityIndicator
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
        self.accessoryType = .disclosureIndicator
        self.accessoryView = nil
    }
    
    func configure(with title: String) {
        textLabel?.text = title
    }
}
