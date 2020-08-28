//
//  UIAlertController+Extension.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

extension UIAlertController {
    /// Add UIAlertAction to a UIAlertController
    /// - Parameters:
    ///   - title: Title for the action
    ///   - style: Style for the action
    ///   - imageName: Name of the image for the action
    ///   - handler: Handler for the action
    func addAction(title: String, style: UIAlertAction.Style, imageName: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        if let imageName = imageName, let image = UIImage(systemName: imageName) ?? UIImage(named: imageName) {
            action.setValue(image, forKey: "image")
        }
        self.addAction(action)
    }
}
