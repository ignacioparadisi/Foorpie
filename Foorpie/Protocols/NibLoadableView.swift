//
//  NibLoadableView.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

public protocol NibLoadableView: class {
    /// Adds a nib name to a view
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    /// Sets the nib name of the view as the name of the class
    static var nibName: String {
        return String(describing: self)
    }
}
