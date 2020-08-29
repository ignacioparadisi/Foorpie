//
//  UIViewController+Extension.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Presents a custom alert
    /// - Parameters:
    ///   - title: Title for the alert
    ///   - message: Message for the alert
    ///   - style: Style of the alert
    ///   - after: Seconds after the alert will disappear
    func showAlert(title: String, message: String, style: AlertView.Style, dismiss after: Double? = 1.5, feedback: UINotificationFeedbackGenerator.FeedbackType? = nil) {
        let alert = CustomAlertViewController(title: title, message: message, style: style, dismiss: after)
        present(alert, animated: true)
        if let feedback = feedback {
            UINotificationFeedbackGenerator().notificationOccurred(feedback)
        }
    }
    
    /// Presents a custom error alert
    /// - Parameters:
    ///   - message: Message for the alert
    ///   - after: Seconds after the alert will disappear
    func showErrorAlert(message: String, dismiss after: Double? = 2) {
        showAlert(title: "Error", message: message, style: .error, dismiss: after, feedback: .error)
    }
    
}
