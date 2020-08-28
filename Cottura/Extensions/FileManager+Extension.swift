//
//  FileManager+Extension.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

extension FileManager {
    static var iCloudDriveDirectory: URL? = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    static var iCloudDriveImagesDirectory: URL? = FileManager.iCloudDriveDirectory?.appendingPathComponent("Images")
}
