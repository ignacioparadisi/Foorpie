//
//  MenuCoreDataManager.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/20/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import CoreData

class MenuCoreDataManager: MenuPersistenceManagerRepresentable {
    static var shared: MenuCoreDataManager = MenuCoreDataManager()
    
    private init() {}
    
    // MARK: - Recipes
    func fetchRecipes(result: (Result<[Recipe], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Recipe.name), ascending: true)]
        do {
            let recipes = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            result(.success(recipes))
        } catch {
            result(.failure(error))
        }
    }
    
    func create(recipe: Recipe, result: (Result<Recipe, Error>) -> Void) {
        recipe.dateCreated = Date()
        do {
            try PersistenceController.shared.saveContext()
            result(.success(recipe))
        } catch {
            result(.failure(error))
        }
    }
    
    func update(recipe: Recipe, result: (Result<Recipe, Error>) -> Void) {
        do {
            try PersistenceController.shared.saveContext()
            result(.success(recipe))
        } catch {
            result(.failure(error))
        }
    }
    
    func delete(recipe: Recipe, result: (Result<Bool, Error>) -> Void) {
        PersistenceController.shared.container.viewContext.delete(recipe)
        result(.success(true))
    }
    
    // MARK: - Ingredients
    func fetchIngredients(result: (Result<[Ingredient], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Ingredient.name), ascending: true)]
        do {
            let ingredients = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            return result(.success(ingredients))
        } catch {
            return result(.failure(error))
        }
    }
    
    func create(ingredient: Ingredient, result: (Result<Ingredient, Error>) -> Void) {
        ingredient.dateCreated = Date()
        do {
            try PersistenceController.shared.saveContext()
            result(.success(ingredient))
        } catch {
            result(.failure(error))
        }
    }
    
    func update(ingredient: Ingredient, result: (Result<Ingredient, Error>) -> Void) {
        do {
            try PersistenceController.shared.saveContext()
            result(.success(ingredient))
        } catch {
            result(.failure(error))
        }
    }
    
    func delete(ingredient: Ingredient, result: (Result<Bool, Error>) -> Void) {
        PersistenceController.shared.container.viewContext.delete(ingredient)
        result(.success(true))
    }
}
