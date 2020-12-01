//
//  RecipeListViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class RecipeListViewModel {
    // MARK: Properties
    /// Recipes to be displayed
    private var dishes: [Recipe] = []
    /// Filtered dished to be displayed
    private var filteredDishes: [Recipe] = []
    /// Text the user has input for filter
    private var filteredText: String?
    /// IndexPath of the selected dish
    private var selectedIndexPath: IndexPath?
    /// Reload table view data if data changed
    var reloadData: (() -> Void)?
    var errorHandler: ((String) -> Void)?
    /// Number of section for the table view
    var numberOfSections: Int {
        return 1
    }
    
    // MARK: Functions
    /// Fetch all dishes to be displayed
    func fetch() {
        let result = MenuPersistenceManager.shared.fetch()
        switch result {
        case .success(let dishes):
            self.dishes = dishes
            self.filteredDishes = dishes
        case .failure:
            errorHandler?(Localizable.Error.fetchingMenu)
        }
    }
    
    /// Number of rows of table view for a specific section
    /// - Parameter section: Section where the rows belong
    /// - Returns: Number of rows for the section
    func numberOfRows(in section: Int) -> Int {
        return filteredDishes.count
    }
    
    /// Dish to be displayed at a specific index path
    /// - Parameter indexPath: Index Path where the dish will be placed
    /// - Returns: Dish to be displayed at the  index path
    func dishForRow(at indexPath: IndexPath) -> RecipeViewModel {
        return RecipeViewModel(dish: filteredDishes[indexPath.row])
    }
    
    /// Delete dish at a specific index path
    /// - Parameter indexPath: Index path of the dish to be deleted
    func deleteDish(at indexPath: IndexPath) {
        MenuPersistenceManager.shared.delete(filteredDishes[indexPath.row])
        filteredDishes.remove(at: indexPath.row)
    }
    
    /// View Model for the dish of the selected index path. If no index path is selected, it returns an empty view model
    /// - Parameter indexPath: Index path selected
    /// - Returns: View Model for the dish of the selected index path
    func detailForRow(at indexPath: IndexPath? = nil) -> RecipeDetailViewModel {
        selectedIndexPath = indexPath
        if let indexPath = indexPath {
            let dish = filteredDishes[indexPath.row]
            let viewModel = RecipeDetailViewModel(dish: dish)
            viewModel.delegate = self
            return viewModel
        } else {
            let viewModel = RecipeDetailViewModel()
            viewModel.delegate = self
            return viewModel
        }
    }
    
    /// Filter items by name compared to the text the user inputs
    /// - Parameter text: Text the user inputs
    func filter(_ text: String?) {
        filteredText = text
        if let text = text, text != "" {
            filteredDishes = dishes.filter {
                $0.name.lowercased().contains(text.lowercased())
            }
        } else {
            filteredDishes = dishes
        }
    }
}

// MARK: - DishDetailViewModelDelegate
extension RecipeListViewModel: DishDetailViewModelDelegate {
    /// Fetch the new data and reload the table
    func refresh() {
        fetch()
        reloadData?()
    }
}
