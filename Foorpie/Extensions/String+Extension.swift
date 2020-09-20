//
//  String+Extension.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

extension String {
    
    /// Returns the string's double value representation if exists
    var doubleValue: Double? {
        return Double(self)
    }
    /// Returns the string encoded for URL
    var urlEncoding: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    
    /// Localize a string
    var localized: String {
        return localized()
    }
    
    /// Localize a string
    /// - Parameters:
    ///   - bundle: Bundle were the localizable file is located
    ///   - tableName: Name of the localizable file
    /// - Returns: A localized string
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: "**\(self)**", comment: "")
    }
    
}
