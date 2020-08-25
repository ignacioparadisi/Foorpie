//
//  MenuItemViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class MenuItemViewModel {
    // MARK: Properties
    private let item: MenuFoodItem
    var name: String {
        return item.name
    }
    var price: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: item.price)) ?? "$0.0"
    }
    var availableCount: Int {
        return Int(item.availableCount)
    }
    var image: UIImage {
        if let stringURL = item.imageURL?.absoluteString,
            let image = UIImage(contentsOfFile: stringURL) {
            return image
        } else {
            return UIImage(systemName: "photo")!
        }
    }
    
    init(item: MenuFoodItem) {
        self.item = item
    }
}
