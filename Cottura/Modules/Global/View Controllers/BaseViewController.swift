//
//  BaseViewController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    private lazy var errorLabel: UILabel = {
         let label = UILabel()
         label.backgroundColor = UIColor.systemRed.withAlphaComponent(0.95)
         label.textColor = .white
         label.textAlignment = .center
         label.heightAnchor.constraint(equalToConstant: 44).isActive = true
         return label
     }()
    private var topSafeAreaHeight: CGFloat {
        return view.safeAreaInsets.top
    }
    private var errorLabelHeightAnchor: NSLayoutConstraint?
    private var errorLabelTopAnchor: NSLayoutConstraint?
    private var timer: Timer?
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViewModel()
        setupView()
    }
    
    /// Called in `viewDidAppear`. This method is for setting up the Navigation Bar
    func setupNavigationBar() {
    }
    
    ///  This functions is the last function called in `viewDidAppear`. It's for setting up the view.
    func setupView() {
    }
    
    /// Called in `viewDidAppear`. This method is for setting up the view model subscriptions and closures.
    func setupViewModel() {
    }
    
    func addErrorMessage() {
        view.addSubview(errorLabel)
        errorLabel.anchor
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
        
        errorLabelHeightAnchor = errorLabel.heightAnchor.constraint(equalToConstant: 0)
        errorLabelHeightAnchor?.isActive = true
        errorLabelTopAnchor = errorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: topSafeAreaHeight)
        errorLabelTopAnchor?.isActive = true
    }
    
    func showErrorMessage(_ message: String) {
        errorLabel.text = message
        errorLabelHeightAnchor?.constant = 44
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval() + 10, repeats: true, block: { [weak self] timer in
            self?.hideErrorMessage()
            timer.invalidate()
        })
    }
    
    private func hideErrorMessage() {
        errorLabelHeightAnchor?.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setErrorMessageTopAnchorConstant(_ constant: CGFloat? = nil) {
        if let constant = constant {
            errorLabelTopAnchor?.constant = constant
        } else {
            errorLabelTopAnchor?.constant = topSafeAreaHeight
        }
    }
}
