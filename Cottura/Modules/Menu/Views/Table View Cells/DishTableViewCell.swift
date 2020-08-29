//
//  DishTableViewCell.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class DishTableViewCell: UITableViewCell, ReusableView, NibLoadableView {
    
    /// Image view for displaying the dish image
    @IBOutlet weak var dishImageView: UIImageView!
    /// Label for displaying dish name
    @IBOutlet weak var nameLabel: UILabel!
    /// Label for displaying dish price
    @IBOutlet weak var priceLabel: UILabel!
    /// Label for displaying dish available count
    @IBOutlet weak var availabilityLabel: UILabel!
    /// View that turns green if there are dished available and red otherwise
    @IBOutlet weak var availabilityView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dishImageView.layer.shadowColor = UIColor.black.cgColor
        dishImageView.layer.shadowRadius = 5
    }
    
    /// Add the information to each view component
    /// - Parameter viewModel: View Model that holds the dish information
    func configure(with viewModel: DishViewModel) {
        dishImageView.image = viewModel.image
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        availabilityView.backgroundColor = viewModel.availableCount > 0 ? .systemGreen : .systemRed
        availabilityLabel.text = "\(viewModel.availableCount) \(Localizable.Text.available)"
    }
    
}
