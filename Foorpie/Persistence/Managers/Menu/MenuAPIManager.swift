//
//  MenuAPIManager.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/20/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class MenuAPIManager: MenuPersistenceManagerRepresentable {
    
    static var shared: MenuAPIManager = MenuAPIManager()
    
    // MARK: - Recipes
    func fetchRecipes(result: (Result<[Recipe], Error>) -> Void) {
    }
    func create(_ recipe: Recipe, result: (Result<Recipe, Error>) -> Void) {
    }
    func update(_ recipe: Recipe, result: (Result<Recipe, Error>) -> Void) {
    }
    func delete(_ recipe: Recipe, result: (Result<Bool, Error>) -> Void) {
    }
    
    // MARK: - Ingredients
    func fetchIngredients(result: (Result<[Ingredient], Error>) -> Void) {
    }
    
}
