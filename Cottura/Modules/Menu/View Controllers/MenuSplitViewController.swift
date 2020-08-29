//
//  MenuSplitViewController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class MenuSplitViewController: UISplitViewController {

    /// Add the View Controller to the Split View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        preferredDisplayMode = .allVisible
        viewControllers = [
            UINavigationController(rootViewController: RecipeListViewController()),
            NoItemSelectedViewController.noRecipeSelected
        ]
    }
}

extension MenuSplitViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        // Always show the master controller
        return true
    }
    
}
