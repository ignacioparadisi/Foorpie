//
//  OrderViewController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class OrderSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        preferredDisplayMode = .allVisible

        viewControllers = [
            UINavigationController(rootViewController: OrderListViewController()),
            NoItemSelectedViewController(title: "No tienes ninguna orden seleccionada", message: "Por favor selecciona una orden para ver su detalle.")
        ]
    }

}

extension OrderSplitViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        // Always show the master controller
        return true
    }
    
}
