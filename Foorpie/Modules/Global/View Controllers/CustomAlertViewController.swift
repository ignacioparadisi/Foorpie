//
//  CustomAlertViewController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/26/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class CustomAlertViewController: UIViewController {
    
    // MARK: Properties
    /// Background for the view. When tapped, the alert dismisses.
    private var backgroundView: UIView = UIView()
    /// Alert view that contains the alert content.
    private var alertView: AlertView!
    /// Timer for dismissing the view after certain amount of time.
    private var timer: Timer?
    /// Amount of time after the alert should be dismissed.
    private let dismissAfter: Double?
    
    // MARK: Initializers
    init(title: String, message: String, style: AlertView.Style, dismissAfter seconds: Double? = 1.5) {
        self.dismissAfter = seconds
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        alertView = AlertView(title: title, message: message, style: style)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    override func viewDidLoad() {
        view.backgroundColor = .clear
        view.addSubview(backgroundView)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        backgroundView.anchor.edgesToSuperview().activate()
        
        view.addSubview(alertView)
        alertView.anchor
            .centerToSuperview()
            .top(greaterOrEqual: view.safeAreaLayoutGuide.topAnchor, constant: 20)
            .trailing(lessOrEqual: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            .bottom(lessOrEqual: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            .leading(greaterOrEqual: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
            .width(greaterThanOrEqualToConstant: 200)
            .width(lessThanOrEqualToConstant: 300)
            .activate()
        alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    /// Dismiss the view
    @objc private func dismissView() {
        dismiss(animated: true) {
            self.timer?.invalidate()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show alert when the view will appear
        showAlert()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Start timer when the view did appear.
        if let dismissAfter = dismissAfter {
            timer = Timer.scheduledTimer(withTimeInterval: TimeInterval() + dismissAfter, repeats: false) { _ in
                self.hideAlert()
            }
        }
    }
    
    /// Show the alert in the screen with a scale animation
    private func showAlert() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 8, options: .curveEaseInOut, animations: {
            self.alertView.transform = CGAffineTransform.identity
        })
    }
    
    /// Removes the alert from the screen with a scale animation
    private func hideAlert() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 8, options: .curveEaseInOut, animations: {
            self.alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.alertView.alpha = 0
        })
        self.dismiss(animated: true) {
            self.timer?.invalidate()
        }
    }
    
}
