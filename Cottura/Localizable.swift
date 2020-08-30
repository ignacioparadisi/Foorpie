//
//  Localizable.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class Localizable {
    
    struct Title {
        static var orders: String = "ordersKey".localized
        static var menu: String = "menuKey".localized
        static var noOrderSelected: String = "noOrderSelectedTitleKey".localized
        static var noRecipeSelected: String = "noRecipeSelectedTitleKey".localized
        static var noIngredientSelected: String = "noIngredientSelectedTitleKey".localized
        static var newRecipe: String = "newRecipeKey".localized
        static var delete: String = "deleteTitleKey".localized
        static var saved: String = "savedTitleKey".localized
        static var ingredients: String = "ingredientsKey".localized
    }
    
    struct Message {
        static var noOrderSelected: String = "noOrderSelectedMessageKey".localized
        static var noRecipeSelected: String = "noRecipeSelectedMessageKey".localized
        static var noIngredientSelected: String = "noIngredientSelectedMessageKey".localized
        static var deleteRecipe: String = "deleteRecipeMessageKey".localized
        static var savedRecipe: String = "savedRecipeMessageKey".localized
    }
    
    struct Text {
        static var order: String = "orderKey".localized
        static var total: String = "totalKey".localized
        static var available: String = "availableKey".localized
        static var name: String = "nameKey".localized
        static var price: String = "priceKey".localized
        static var availableCount: String = "availableCountKey".localized
        static var search: String = "searchKey".localized
    }
    
    struct Button {
        static var done: String = "doneKey".localized
        static var resetPhoto: String = "resetPhotoKey".localized
        static var takePhoto: String = "takePhotoKey".localized
        static var choosePhoto: String = "choosePhotoKey".localized
        static var cancel: String = "cancelKey".localized
        static var delete: String = "deleteKey".localized
    }
    
    struct Error {
        static var fetchingMenu: String = "fetchingMenuErrorKey".localized
        static var saveRecipe: String = "saveRecipeErrorKey".localized
        static var resetImage: String = "resetImageErrorKey".localized
    }
    
}
