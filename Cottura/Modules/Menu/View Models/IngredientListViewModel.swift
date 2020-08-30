//
//  IngredientListViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class IngredientListViewModel {
    // MARK: Properties
    private var ingredients: [Ingredient] = []
    private var filteredIngredients: [Ingredient] = []
    private var filteredText: String?
    var numberOfRows: Int {
        return 10 // filteredIngredients.count
    }
    
    // MARK: Functions
    /// Filter items by name compared to the text the user inputs
    /// - Parameter text: Text the user inputs
    func filter(_ text: String?) {
        filteredText = text
        if let text = text, text != "" {
            filteredIngredients = ingredients.filter {
                $0.name.lowercased().contains(text.lowercased())
            }
        } else {
            filteredIngredients = ingredients
        }
    }
}
