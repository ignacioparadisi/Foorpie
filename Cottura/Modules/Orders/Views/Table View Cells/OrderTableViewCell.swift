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
    private let notesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
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
    private let recipeOrderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 240, height: 220)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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
        contentView.addSubview(orderNumberLabel)
        contentView.addSubview(clientNameLabel)
        contentView.addSubview(recipeOrderCollectionView)
        contentView.addSubview(totalPriceLabel)
        
        let statusButtonContainerView = UIView()
        statusButtonContainerView.backgroundColor = .clear
        contentView.addSubview(statusButtonContainerView)
        statusButtonContainerView.addSubview(orderStatusButton)
        
        orderNumberLabel.anchor
            .topToSuperview(constant: verticalMargin)
            .leadingToSuperview(constant: horizontalMargin)
            .trailing(to: clientNameLabel.trailingAnchor)
            .activate()
        clientNameLabel.anchor
            .top(to: orderNumberLabel.bottomAnchor, constant: 5)
            .leadingToSuperview(constant: horizontalMargin)
            .activate()
        statusButtonContainerView.anchor
            .topToSuperview(constant: verticalMargin)
            .leading(greaterOrEqual: clientNameLabel.trailingAnchor, constant: 10)
            .bottom(to: clientNameLabel.bottomAnchor)
            .trailingToSuperview(constant: -horizontalMargin)
            .activate()
        recipeOrderCollectionView.anchor
            .top(to: clientNameLabel.bottomAnchor, constant: 10)
            .leadingToSuperview()
            .trailingToSuperview()
            .height(constant: 220)
            .activate()
        totalPriceLabel.anchor
            .top(to: recipeOrderCollectionView.bottomAnchor, constant: 10)
            .leadingToSuperview(constant: horizontalMargin)
            .bottomToSuperview(constant: -verticalMargin)
            .trailingToSuperview(constant: -horizontalMargin)
            .activate()
        
        orderStatusButton.anchor
            .centerYToSuperview()
            .trailingToSuperview()
            .top(greaterOrEqual: statusButtonContainerView.topAnchor)
            .bottom(lessOrEqual: statusButtonContainerView.bottomAnchor)
            .leadingToSuperview()
            .activate()
        
        recipeOrderCollectionView.dataSource = self
        recipeOrderCollectionView.register(OrderPlateCollectionViewCell.self)
    }
    
    func configure(orderNumber: Int, clientName: String, status: String) {
        orderNumberLabel.text = "\(Localizable.Text.order) \(orderNumber)"
        clientNameLabel.text = clientName
        orderStatusButton.setTitle(status, for: .normal)
        orderStatusButton.setTitleColor(.white, for: .normal)
        orderStatusButton.backgroundColor = .systemBlue
        totalPriceLabel.text = "\(Localizable.Text.total): $14.00"
    }
}

extension OrderTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as OrderPlateCollectionViewCell
        return cell
    }
}
