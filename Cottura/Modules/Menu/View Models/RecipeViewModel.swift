//
//  RecipeViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class RecipeViewModel {
    // MARK: Properties
    /// Recipe where the information comes
    private let recipe: Recipe
    /// Name of the recipe
    var name: String {
        return recipe.name
    }
    /// Price of the recipe
    var price: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: recipe.price)) ?? "$0.0"
    }
    /// Available count of the recipe
    var availableCount: Int {
        return Int(recipe.availableCount)
    }
    /// Image of the recipe
    var image: UIImage {
        if let data = recipe.imageData,
            let image = UIImage(data: data) {
            return image
        } else {
            let image = UIImage.photo!.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .small))!
            return image.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
        }
    }
    
    // MARK: Initializer
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
