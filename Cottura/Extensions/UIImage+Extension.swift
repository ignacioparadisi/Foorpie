//
//  UIImage+Extension.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

extension UIImage {
    /// Converts an image into JPEG data compressing it to 0.5 of it's original quality
    var jpegCompressedData: Data? {
        return self.jpegData(compressionQuality: 0.5)
    }
}
