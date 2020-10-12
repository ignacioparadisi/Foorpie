//
//  LocalizedStrings.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 8/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class LocalizedStrings {
    
    struct Title {
        static var companies: String = "Title.companies.key".localized
        static var company: String = "Title.company.key".localized
        static var error: String = "Title.error.key".localized
        static var ingredients: String = "Title.ingredients.key".localized
        static var newIngredient = "Title.newIngredient.key".localized
        static var newRecipe: String = "Title.newRecipe.key".localized
        static var noIngredientSelected: String = "Title.noIngredientSelected.key".localized
        static var noOrderSelected: String = "Title.noOrderSelected.key".localized
        static var noRecipeSelected: String = "Title.noRecipeSelected.key".localized
        static var orders: String = "Title.orders.key".localized
        static var profile: String = "Title.profile.key".localized
        static var recipes: String = "Title.recipes.key".localized
        static var settings: String = "Title.settings.key".localized
        static var users: String = "Title.users.key".localized
    }
    
    struct Message {
        static var ingredientPriceDetailInfo: String = "Message.ingredientPriceDetailInfo.key".localized
        static var invitationDetail: String = "Message.invitationDetail.key".localized
        static var noIngredientSelected: String = "Message.noIngredientSelected.key".localized
        static var noOrderSelected: String = "Message.noOrderSelected.key".localized
        static var noRecipeSelected: String = "Message.noRecipeSelected.key".localized
    }
    
    struct Text {
        static var available: String = "Text.available.key".localized
        static var availableAmount: String = "Text.availableAmount.key".localized
        static var availableCount: String = "Text.availableCount.key".localized
        static var centimeters: String = "Text.centimeters.key".localized
        static var feet: String = "Text.feet.key".localized
        static var gallon: String = "Text.gallon.key".localized
        static var gram: String = "Text.gram.key".localized
        static var inch: String = "Text.inch.key".localized
        static var kilogram: String = "Text.kilogram.key".localized
        static var liter: String = "Text.liter.key".localized
        static var loading: String = "Text.loading.key".localized
        static var loggingOut: String = "Text.loggingOut.key".localized
        static var meters: String = "Text.meters.key".localized
        static var milligram: String = "Text.milligram.key".localized
        static var milliliter: String = "Text.milliliter.key".localized
        static var name: String = "Text.name.key".localized
        static var order: String = "Text.order.key".localized
        static var ounce: String = "Text.ounce.key".localized
        static var pound: String = "Text.pound.key".localized
        static var price: String = "Text.price.key".localized
        static var search: String = "Text.search.key".localized
        static var total: String = "Text.total.key".localized
        static var unit: String = "Text.unit.key".localized
    }
    
    struct Button {
        static var acceptInvitation: String = "Button.acceptInvitation.key".localized
        static var cancel: String = "Button.cancel.key".localized
        static var choosePhoto: String = "Button.choosePhoto.key".localized
        static var delete: String = "Button.delete.key".localized
        static var done: String = "Button.done.key".localized
        static var inviteUser = "Button.inviteUser.key".localized
        static var logout: String = "Button.logout.key".localized
        static var ok: String = "Button.ok.key".localized
        static var resetPhoto: String = "Button.resetPhoto.key".localized
        static var save: String = "Button.save.key".localized
        static var takePhoto: String = "Button.takePhoto.key".localized
    }
    
    struct Error {
        static var fetchingMenu: String = "Error.fetchingMenu.key".localized
        static var resetImage: String = "Error.resetImage.key".localized
        static var saveRecipe: String = "Error.saveRecipe.key".localized
    }
    
    struct AlertTitle {
        static var delete: String = "AlertTitle.delete.key".localized
        static var createCompany: String = "AlertTitle.createCompany.key".localized
        static var loginError: String = "AlertTitle.loginError.key".localized
        static var logoutError: String = "AlertTitle.logoutError.key".localized
        static var logoutQuestion: String = "AlertTitle.logoutQuestion.key".localized
        static var saved: String = "AlertTitle.saved.key".localized
    }
    
    struct AlertMessage {
        static var deleteRecipe: String = "AlertMessage.deleteRecipe.key".localized
        static var deleteCompany: String = "AlertMessage.deleteCompany.key".localized
        static var createCompany: String = "AlertMessage.createCompany.key".localized
        static var loginError: String = "AlertMessage.loginError.key".localized
        static var logoutError: String = "AlertMessage.logoutError.key".localized
        static var savedRecipe: String = "AlertMessage.savedRecipe.key".localized
    }
    
}
