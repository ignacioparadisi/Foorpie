//
//  MenuItemTableViewCell.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell, ReusableView, NibLoadableView {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var availabilityView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemImageView.layer.shadowColor = UIColor.black.cgColor
        itemImageView.layer.shadowRadius = 5
    }
    
    func configure(with viewModel: MenuItemViewModel) {
        itemImageView.image = viewModel.image
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        availabilityView.backgroundColor = viewModel.availableCount > 0 ? .systemGreen : .systemRed
        availabilityLabel.text = "\(viewModel.availableCount) Disponibles"
    }
    
}
