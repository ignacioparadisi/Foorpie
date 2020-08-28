//
//  DishViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class DishViewModel {
    // MARK: Properties
    /// Dish where the information comes
    private let dish: Dish
    /// Name of the dish
    var name: String {
        return dish.name
    }
    /// Price of the dish
    var price: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: dish.price)) ?? "$0.0"
    }
    /// Available count of the dish
    var availableCount: Int {
        return Int(dish.availableCount)
    }
    /// Image of the dish
    var image: UIImage {
        if let data = dish.imageData,
            let image = UIImage(data: data) {
            return image
        } else {
            let image = UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(scale: .small))!
            return image.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
        }
    }
    
    // MARK: Initializer
    init(dish: Dish) {
        self.dish = dish
    }
}
