//
//  MainTabBarController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    private let orderListViewController = OrderListViewController()
    private let menuViewController = MenuViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [orderListViewController, menuViewController]
    }


}

