//
//  UIView+Extension.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

extension UIView {
    
    func shrink() {
        UIView.animate(withDuration: 0.1,
        animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        },
        completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform.identity
            }
        })
    }
}
