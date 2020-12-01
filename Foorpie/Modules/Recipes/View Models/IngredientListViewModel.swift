//
//  IngredientListViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import MobileCoreServices

//class IngredientViewModel: Hashable {
//    private let ingredient: Ingredient
//    var name: String {
//        return ingredient.name
//    }
//    var price: Double {
//        return ingredient.price
//    }
//    var unitAmount: Double {
//        return ingredient.unitAmount
//    }
//    var unit: Ingredient.UnitType? {
//        return Ingredient.UnitType(rawValue: ingredient.unitType)
//    }
//
//    init(ingredient: Ingredient) {
//        self.ingredient = ingredient
//    }
//
//    static func == (lhs: IngredientViewModel, rhs: IngredientViewModel) -> Bool {
//        return lhs.name == rhs.name &&
//            lhs.price == rhs.price &&
//            lhs.unitAmount == rhs.unitAmount &&
//            lhs.unit == rhs.unit
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(name)
//        hasher.combine(price)
//        hasher.combine(unitAmount)
//        hasher.combine(unit)
//    }
//}

class IngredientListViewModel {
    enum Section: Int, CaseIterable {
        case ingredients
    }
    // MARK: Properties
    private var ingredients: [Ingredient] = []
    private var filteredIngredients: [Ingredient] = []
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
        APIManagerFactory.menuPersistenceManager.fetchIngredients { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let ingredients):
                self.ingredients = ingredients
                self.filteredIngredients = self.ingredients
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func text(for indexPath: IndexPath) -> String {
        let ingredient = filteredIngredients[indexPath.row]
        return ingredient.name
    }
    
    func detailForRow(at indexPath: IndexPath?) -> IngredientDetailViewModel {
        var viewModel = IngredientDetailViewModel()
        if let indexPath = indexPath {
            let ingredient = ingredients[indexPath.row]
            viewModel = IngredientDetailViewModel(ingredient: ingredient)
        }
        viewModel.delegate = self
        return viewModel
    }
    
    /// Creates a drag item from a Recipe
    /// - Parameter indexPath: Index path where the recipe is listed
    /// - Returns: An array with a drag item if the cell can be dragged.
    func dragItemForRow(at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.section != 0 { return [] }
        let ingredient = ingredients[indexPath.row]
        guard let data = "ingredient:\(ingredient.uuid.uuidString)".data(using: .utf8) else { return [] }
        let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = ingredient
        return [dragItem]
    }
}

extension IngredientListViewModel: IngredientDetailViewModelDelegate {
    func refresh() {
        fetch()
    }
}
