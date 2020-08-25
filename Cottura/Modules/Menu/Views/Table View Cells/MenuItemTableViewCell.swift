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
    
    func configure(with: MenuItemViewModel) {
        itemImageView.image = UIImage(named: "pizza")
        nameLabel.text = "Pizza American Pepperoni"
        priceLabel.text = "$7.00"
        availabilityView.backgroundColor = .systemGreen
        availabilityLabel.text = "10 Disponibles"
    }
    
}
