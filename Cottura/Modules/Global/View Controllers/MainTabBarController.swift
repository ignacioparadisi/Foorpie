//
//  MainTabBarController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    // MARK: Properties
    /// View controller for listing orders
    private let orderSplitViewController = OrderSplitViewController()
    /// View controller for listing recipes
    private let menuSplitViewController = MenuSplitViewController()
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        orderSplitViewController.tabBarItem = UITabBarItem(title: Localizable.Title.orders, image: .trayFull, tag: 0)
        if #available(iOS 14, *) {
            menuSplitViewController.tabBarItem = UITabBarItem(title: Localizable.Title.menu, image: .walletPass, tag: 1)
        } else {
            menuSplitViewController.tabBarItem = UITabBarItem(title: Localizable.Title.menu, image: .docPlaintext, tag: 1)
        }
        menuSplitViewController.preferredDisplayMode = .allVisible
        viewControllers = [
            orderSplitViewController,
            menuSplitViewController
        ]
    }
}

