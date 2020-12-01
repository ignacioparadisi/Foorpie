//
//  UIImage+Extension.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

// MARK: - SF Symbol Icons
extension UIImage {
    
    static var camera: UIImage? = UIImage(systemName: "camera")
    static var cameraFill: UIImage? = UIImage(systemName: "camera.fill")
    static var cartFill: UIImage? = UIImage(systemName: "cart.fill")
    static var checkmarkCircle: UIImage? = UIImage(systemName: "checkmark.circle")
    static var crownFill: UIImage? = UIImage(systemName: "crown.fill")
    static var docPlaintext: UIImage? = UIImage(systemName: "doc.plaintext")
    static var docPlaintextFill: UIImage? = UIImage(systemName: "doc.plaintext.fill")
    static var gearshape: UIImage? = UIImage(systemName: "gearshape")
    static var gearshapeFill: UIImage? = UIImage(systemName: "gearshape.fill")
    static var personCropCircle: UIImage? = UIImage(systemName: "person.crop.circle")
    static var personCropCircleFill: UIImage? = UIImage(systemName: "person.crop.circle.fill")
    static var photo: UIImage? = UIImage(systemName: "photo")
    static var photoOnRectangle: UIImage? = UIImage(systemName: "photo.on.rectangle")
    static var plus: UIImage? = UIImage(systemName: "plus")
    static var trash: UIImage? = UIImage(systemName: "trash")
    static var trayFull: UIImage? = UIImage(systemName: "tray.full")
    static var trayFullFill: UIImage? = UIImage(systemName: "tray.full.fill")
    static var xmarkCircle: UIImage? = UIImage(systemName: "xmark.circle")
    
}

extension UIImage {
    /// Converts an image into JPEG data compressing it to 0.5 of it's original quality
    var jpegCompressedData: Data? {
        return self.jpegData(compressionQuality: 0.5)
    }
}
