//
//  RecipeTableViewCell.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell, ReusableView, NibLoadableView {
    
    /// Image view for displaying the recipe image
    @IBOutlet weak var recipeImageView: UIImageView!
    /// Label for displaying recipe name
    @IBOutlet weak var nameLabel: UILabel!
    /// Label for displaying recipe price
    @IBOutlet weak var priceLabel: UILabel!
    /// Label for displaying recipe available count
    @IBOutlet weak var availabilityLabel: UILabel!
    /// View that turns green if there are recipes available and red otherwise
    @IBOutlet weak var availabilityView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recipeImageView.layer.shadowColor = UIColor.black.cgColor
        recipeImageView.layer.shadowRadius = 5
    }
    
    /// Add the information to each view component
    /// - Parameter viewModel: View Model that holds the recipe information
    func configure(with viewModel: RecipeViewModel) {
        recipeImageView.image = viewModel.image
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        availabilityView.backgroundColor = viewModel.availableCount > 0 ? .systemGreen : .systemRed
        availabilityLabel.text = "\(viewModel.availableCount) \(Localizable.Text.available)"
    }
    
}
