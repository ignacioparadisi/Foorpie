//
//  IngredientListViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class IngredientViewModel: Hashable {
    private let ingredient: Ingredient
    var name: String {
        return ingredient.name
    }
    var price: Double {
        return ingredient.price
    }
    var unitCount: Int {
        return Int(ingredient.unitCount)
    }
    var unit: String {
        return ingredient.unit
    }
    
    init(ingredient: Ingredient) {
        self.ingredient = ingredient
    }
    
    static func == (lhs: IngredientViewModel, rhs: IngredientViewModel) -> Bool {
        return lhs.name == rhs.name &&
            lhs.price == rhs.price &&
            lhs.unitCount == rhs.unitCount &&
            lhs.unit == rhs.unit
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(price)
        hasher.combine(unitCount)
        hasher.combine(unit)
    }
}

class IngredientListViewModel {
    enum Section: Int, CaseIterable {
        case ingredients
    }
    // MARK: Properties
    private var ingredients: [IngredientViewModel] = []
    var filteredIngredients: [IngredientViewModel] = []
    private var filteredText: String?
    var numberOfRows: Int {
        filteredIngredients.count
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
    
    func fetch() {
        let result = MenuPersistenceManager.shared.fetchIngredients()
        switch result {
        case .success(let ingredients):
            self.ingredients = ingredients.map { IngredientViewModel(ingredient: $0) }
            self.filteredIngredients = self.ingredients
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func text(for indexPath: IndexPath) -> String {
        let ingredient = filteredIngredients[indexPath.row]
        return ingredient.name
    }
}
