//
//  OrderViewController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class OrderSplitViewController: UISplitViewController {
    
    let orderListViewController = OrderListViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [
            orderListViewController,
            NoItemSelectedViewController(title: "No tienes ninguna orden seleccionada", message: "Por favor selecciona una orden para ver su detalle.")
        ]
    }

}
