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
    func create(recipe: Recipe, result: (Result<Recipe, Error>) -> Void) {
    }
    func update(recipe: Recipe, result: (Result<Recipe, Error>) -> Void) {
    }
    func delete(recipe: Recipe, result: (Result<Bool, Error>) -> Void) {
    }
    
    // MARK: - Ingredients
    func fetchIngredients(result: (Result<[Ingredient], Error>) -> Void) {
    }
    func create(ingredient: Ingredient, result: (Result<Ingredient, Error>) -> Void) {
    }
    func update(ingredient: Ingredient, result: (Result<Ingredient, Error>) -> Void) {
    }
    func delete(ingredient: Ingredient, result: (Result<Bool, Error>) -> Void) {
    }
    
}
