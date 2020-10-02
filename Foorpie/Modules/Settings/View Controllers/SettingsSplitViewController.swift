//
//  SettingsSplitViewController.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/2/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class SettingsSplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        preferredDisplayMode = .allVisible

        viewControllers = [
            UINavigationController(rootViewController: SettingsViewController()),
            UIViewController()
        ]
    }
}

extension SettingsSplitViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        // Always show the master controller
        return true
    }
    
}
