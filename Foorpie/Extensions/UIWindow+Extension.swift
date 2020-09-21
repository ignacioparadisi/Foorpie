//
//  UIWindow+Extension.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/21/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

extension UIWindow {
    func setRootViewController(_ viewController: UIViewController) {
        if let snapshot = self.snapshotView(afterScreenUpdates: true) {
            viewController.view.addSubview(snapshot)
            snapshot.anchor.edgesToSuperview().activate()
            self.rootViewController = viewController
            UIView.animate(withDuration: 0.3, animations: {
                snapshot.alpha = 0
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
        } else {
            self.rootViewController = viewController
        }
        self.makeKeyAndVisible()
    }
}
