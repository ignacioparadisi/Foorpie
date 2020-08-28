//
//  FileManager+Extension.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

//extension FileManager {
//    static var iCloudDriveDirectory: URL? = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
//    static var iCloudDriveImagesDirectory: URL? = FileManager.iCloudDriveDirectory?.appendingPathComponent("Images")
//}
//
//private func saveImage(named name: String, completion: @escaping (Result<URL, Error>) -> Void) {
//    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//        guard let self = self else {
//            DispatchQueue.main.async {
//                completion(.failure(SaveImageError.invalidSelf))
//            }
//            return
//        }
//        // Get URL paths for iCloud Drive
//        guard let iCloudDirectory = FileManager.iCloudDriveDirectory, let iCloudImageDirectory = FileManager.iCloudDriveImagesDirectory else {
//            DispatchQueue.main.async {
//                completion(.failure(SaveImageError.invalidPath("iCloud Drive")))
//            }
//            return
//        }
//        // Convert image name to url format
//        guard let imageName = name.urlEncoding else {
//            DispatchQueue.main.async {
//                completion(.failure(SaveImageError.nameToURLFormat))
//            }
//            return
//        }
//        let imageURL = iCloudImageDirectory.appendingPathComponent("\(imageName).jpeg")
//        // Convert image to JPEG data
//        guard let data = self.image?.jpegCompressedData else {
//            DispatchQueue.main.async {
//                completion(.failure(SaveImageError.jpegConversion))
//            }
//            return
//        }
//        // Create directories if necessary
//        do {
//            try self.createDirectoryIfNeeded(iCloudDirectory)
//            try self.createDirectoryIfNeeded(iCloudImageDirectory)
//            try self.removeFiletIfExists(imageURL)
//            try self.createFile(data, in: imageURL)
//            DispatchQueue.main.async {
//                print("Image saved in \(imageURL)")
//                completion(.success(imageURL))
//                return
//            }
//        } catch {
//            DispatchQueue.main.async {
//                completion(.failure(error))
//            }
//        }
//    }
//}
//
//private func createDirectoryIfNeeded(_ url: URL) throws {
//    if (!FileManager.default.fileExists(atPath: url.path, isDirectory: nil)) {
//        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
//    }
//}
//
//private func removeFiletIfExists(_ url: URL) throws {
//    if FileManager.default.fileExists(atPath: url.path) {
//        try FileManager.default.removeItem(atPath: url.path)
//    }
//}
//
//private func createFile(_ data: Data, in url: URL) throws {
//    try data.write(to: url)
//}
//
//private func returnImage(url: URL?, completion: @escaping (Result<URL?, Error>) -> Void) {
//    DispatchQueue.main.async {
//        completion(.success(url))
//        return
//    }
//}
//
//private func deleteFile(at url: URL) throws {
//    guard url.startAccessingSecurityScopedResource() else { return }
//    defer { url.stopAccessingSecurityScopedResource() }
//    try FileManager.default.removeItem(at: url)
//}
