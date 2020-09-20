//
//  RecipeListViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import MobileCoreServices

class RecipeListViewModel {
    // MARK: Properties
    enum Section: Int, CaseIterable {
        case ingredients
        case recipes
    }
    /// Recipes to be displayed
    private var recipes: [Recipe] = []
    /// Filtered recipes to be displayed
    private var filteredRecipes: [Recipe] = []
    /// Text the user has input for filter
    private var filteredText: String?
    /// IndexPath of the selected recipe
    private var selectedIndexPath: IndexPath?
    /// Reload table view data if data changed
    var reloadData: (() -> Void)?
    var errorHandler: ((String) -> Void)?
    /// Number of section for the table view
    var numberOfSections: Int {
        return Section.allCases.count
    }
    
    // MARK: Functions
    /// Fetch all recipes to be displayed
    func fetch() {
        let result = MenuPersistenceManager.shared.fetch()
        switch result {
        case .success(let recipes):
            self.recipes = recipes
            self.filteredRecipes = recipes
        case .failure:
            errorHandler?(Localizable.Error.fetchingMenu)
        }
    }
    
    func section(for indexPath: IndexPath) -> Section? {
        return  Section(rawValue: indexPath.section)
    }
    
    /// Number of rows of table view for a specific section
    /// - Parameter section: Section where the rows belong
    /// - Returns: Number of rows for the section
    func numberOfRows(in section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .ingredients:
            return 1
        case .recipes:
            return filteredRecipes.count
        }
    }
    
    /// Recipe to be displayed at a specific index path
    /// - Parameter indexPath: Index Path where the recipe will be placed
    /// - Returns: Recipe to be displayed at the  index path
    func recipeForRow(at indexPath: IndexPath) -> RecipeViewModel {
        return RecipeViewModel(recipe: filteredRecipes[indexPath.row])
    }
    
    /// Delete recipe at a specific index path
    /// - Parameter indexPath: Index path of the recipe to be deleted
    func deleteRecipe(at indexPath: IndexPath) {
        MenuPersistenceManager.shared.delete(filteredRecipes[indexPath.row])
        filteredRecipes.remove(at: indexPath.row)
    }
    
    /// View Model for the recipe of the selected index path. If no index path is selected, it returns an empty view model
    /// - Parameter indexPath: Index path selected
    /// - Returns: View Model for the recipe of the selected index path
    func detailForRow(at indexPath: IndexPath? = nil) -> RecipeDetailViewModel {
        selectedIndexPath = indexPath
        if let indexPath = indexPath {
            let recipe = filteredRecipes[indexPath.row]
            let viewModel = RecipeDetailViewModel(recipe: recipe)
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
            filteredRecipes = recipes.filter {
                $0.name.lowercased().contains(text.lowercased())
            }
        } else {
            filteredRecipes = recipes
        }
    }
    
    /// Creates a drag item from a Recipe
    /// - Parameter indexPath: Index path where the recipe is listed
    /// - Returns: An array with a drag item if the cell can be dragged.
    func dragItemsForRow(at indexPath: IndexPath) -> [UIDragItem] {
        if section(for: indexPath) != .recipes { return [] }
        let recipe = recipes[indexPath.row]
        guard let data = recipe.name.data(using: .utf8) else { return [] }
        let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = recipe
        return [dragItem]
    }
}

// MARK: - RecipeDetailViewModelDelegate
extension RecipeListViewModel: RecipeDetailViewModelDelegate {
    /// Fetch the new data and reload the table
    func refresh() {
        fetch()
        reloadData?()
    }
}
