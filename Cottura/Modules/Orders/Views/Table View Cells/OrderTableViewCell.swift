//
//  OrderTableViewCell.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell, ReusableView {
    // MARK: Properties
    private let verticalMargin: CGFloat = 8
    private let horizontalMargin: CGFloat = 16
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let orderNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote).bold
        label.textColor = .systemBlue
        return label
    }()
    private let clientNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    private let orderStatusButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote).bold
        button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15)
        return button
    }()
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2).bold
        return label
    }()
    private let orderDishCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.cornerRadius = 15
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .secondarySystemBackground
        return collectionView
    }()
    
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
        contentView.addSubview(containerView)
        containerView.anchor
            .edgesToSuperview(insets: UIEdgeInsets(top: verticalMargin, left: horizontalMargin, bottom: -verticalMargin, right: -horizontalMargin))
            .activate()
        
        containerView.addSubview(orderNumberLabel)
        containerView.addSubview(clientNameLabel)
        containerView.addSubview(orderStatusButton)
        containerView.addSubview(totalPriceLabel)
        
        orderStatusButton.anchor
            .topToSuperview()
            .trailingToSuperview()
            .activate()
        orderNumberLabel.anchor
            .topToSuperview()
            .leadingToSuperview()
            .bottom(to: orderStatusButton.bottomAnchor)
            .trailing(to: orderStatusButton.leadingAnchor, constant: -10)
            .activate()
        clientNameLabel.anchor
            .top(to: orderStatusButton.bottomAnchor, constant: 5)
            .leadingToSuperview()
            .trailingToSuperview()
            .activate()
        containerView.addSubview(orderDishCollectionView)
        orderDishCollectionView.anchor
            .top(to: clientNameLabel.bottomAnchor, constant: 10)
            .leadingToSuperview()
            .trailingToSuperview()
            .height(constant: 150)
            .activate()
        totalPriceLabel.anchor
            .top(to: orderDishCollectionView.bottomAnchor, constant: 10)
            .leadingToSuperview()
            .bottomToSuperview()
            .trailingToSuperview()
            .activate()
    }
    
    func configure(orderNumber: Int, clientName: String, status: String) {
        orderNumberLabel.text = "Orden \(orderNumber)"
        clientNameLabel.text = clientName
        orderStatusButton.setTitle(status, for: .normal)
        orderStatusButton.setTitleColor(.white, for: .normal)
        orderStatusButton.backgroundColor = .systemBlue
        totalPriceLabel.text = "Total: $14.00"
    }
}
