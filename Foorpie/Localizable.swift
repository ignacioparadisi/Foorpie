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
        static var delete: String = "deleteTitleKey".localized
        static var error: String = "errorKey".localized
        static var ingredients: String = "ingredientsKey".localized
        static var loginError: String = "loginErrorTitleKey".localized
        static var logoutQuestion: String = "logoutQuestionKey".localized
        static var menu: String = "menuKey".localized
        static var newIngredient = "newIngredientKey".localized
        static var newRecipe: String = "newRecipeKey".localized
        static var noIngredientSelected: String = "noIngredientSelectedTitleKey".localized
        static var noOrderSelected: String = "noOrderSelectedTitleKey".localized
        static var noRecipeSelected: String = "noRecipeSelectedTitleKey".localized
        static var orders: String = "ordersKey".localized
        static var profile: String = "profileKey".localized
        static var recipes: String = "recipesKey".localized
        static var saved: String = "savedTitleKey".localized
        static var settings: String = "settingsKey".localized
    }
    
    struct Message {
        static var deleteRecipe: String = "deleteRecipeMessageKey".localized
        static var ingredientPriceDetailInfo: String = "ingredientPriceDetailInfoKey".localized
        static var loginError: String = "loginErrorMessageKey".localized
        static var noIngredientSelected: String = "noIngredientSelectedMessageKey".localized
        static var noOrderSelected: String = "noOrderSelectedMessageKey".localized
        static var noRecipeSelected: String = "noRecipeSelectedMessageKey".localized
        static var savedRecipe: String = "savedRecipeMessageKey".localized
    }
    
    struct Text {
        static var available: String = "availableKey".localized
        static var availableAmount: String = "availableAmountKey".localized
        static var availableCount: String = "availableCountKey".localized
        static var centimeters: String = "centimeterKey".localized
        static var feet: String = "feetKey".localized
        static var gallon: String = "gallonKey".localized
        static var gram: String = "gramKey".localized
        static var inch: String = "inchKey".localized
        static var kilogram: String = "kilogramKey".localized
        static var liter: String = "literKey".localized
        static var loading: String = "loadingKey".localized
        static var meters: String = "meterKey".localized
        static var milligram: String = "milligramKey".localized
        static var milliliter: String = "milliliterKey".localized
        static var name: String = "nameKey".localized
        static var order: String = "orderKey".localized
        static var ounce: String = "onceKey".localized
        static var pound: String = "poundKey".localized
        static var price: String = "priceKey".localized
        static var search: String = "searchKey".localized
        static var total: String = "totalKey".localized
        static var unit: String = "unitKey".localized
    }
    
    struct Button {
        static var cancel: String = "cancelKey".localized
        static var choosePhoto: String = "choosePhotoKey".localized
        static var delete: String = "deleteKey".localized
        static var done: String = "doneKey".localized
        static var logout: String = "logoutKey".localized
        static var ok: String = "okKey".localized
        static var resetPhoto: String = "resetPhotoKey".localized
        static var save: String = "saveKey".localized
        static var takePhoto: String = "takePhotoKey".localized
    }
    
    struct Error {
        static var fetchingMenu: String = "fetchingMenuErrorKey".localized
        static var resetImage: String = "resetImageErrorKey".localized
        static var saveRecipe: String = "saveRecipeErrorKey".localized
    }
    
}
