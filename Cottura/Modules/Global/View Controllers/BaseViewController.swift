//
//  BaseViewController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
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
}
