//
//  MenuItemDetailViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

enum SaveImageError: Error {
    case invalidPath(String)
    case nameToURLFormat
    case jpegConversion
    case invalidSelf
}

protocol MenuItemDetailViewModelDelegate {
    func refresh()
}

class MenuItemDetailViewModel {
    private var item: MenuFoodItem?
    private var fields: [FieldViewModel] = []
    var delegate: MenuItemDetailViewModelDelegate?
    var image: UIImage?
    @Published var imageDidChange: Bool = false
    var isEditing: Bool {
        return item != nil
    }
    var numberOfSections: Int {
        if isEditing {
            return MenuItemDetailViewController.Section.allCases.count
        } else {
            return MenuItemDetailViewController.Section.allCases.count - 1
        }
    }
    var title: String {
        if let item = item {
            return item.name
        } else {
            return "Nuevo Artículo"
        }
    }
    
    init(item: MenuFoodItem? = nil) {
        self.item = item
        if let imageURL = item?.imageURL {
            image = UIImage(contentsOfFile: imageURL.path)
        }
        setupFields()
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let section = MenuItemDetailViewController.Section(rawValue: section) else { return 0 }
        switch section {
        case .photo:
            return 1
        case .fields:
            return fields.count
        case .delete:
            return isEditing ? 1: 0
        }
    }
    
    func fieldForRow(at indexPath: IndexPath) -> FieldViewModel {
        let field = fields[indexPath.row]
        return field
    }
    
    private func setupFields() {
        var availableCount: Int?
        if let item = item {
            availableCount = Int(item.availableCount)
        }
        let nameField = TextFieldCellViewModel(title: "Nombre", value: item?.name)
        nameField.validations = [.required]
        let priceField = CurrencyTextFieldCellViewModel(title: "Precio", placeholder: "$0.00", value: item?.price)
        priceField.validations = [.required]
        let availabilityField = IntTextFieldCellViewModel(title: "Cantidad Disponible", value: availableCount)
        availabilityField.validations = [.required]
        fields = [
            nameField,
            priceField,
            availabilityField
        ]
    }
    
    var fieldsAreValid: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest3(fields[0].$isValid, fields[1].$isValid, fields[2].$isValid)
            .map { $0 && $1 && $2 }
            .eraseToAnyPublisher()
    }
    
    var fieldsAreChanged: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest4(fields[0].$isChanged, fields[1].$isChanged, fields[2].$isChanged, $imageDidChange)
            .map { name, price, availability, image in
                return name || price || availability || image
            }
            .eraseToAnyPublisher()
    }
    
    var readyToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(fieldsAreValid, fieldsAreChanged)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    
    func save() {
        if let path = item?.imageURL?.path {
            let savedImage = UIImage(contentsOfFile: path)
            print(savedImage == image)
        }
        guard let name = fields[0].stringValue else { return }
        guard let price = fields[1].stringValue?.doubleValue else { return }
        guard let availableCount = Int32(fields[2].stringValue ?? "0") else { return }
        var newItem: MenuFoodItem!
        if !name.isEmpty {
            if let item = item {
                newItem = item
            } else {
                newItem = MenuFoodItem(context: PersistenceController.shared.container.viewContext)
                newItem.dateCreated = Date()
            }
            newItem.name = name
            newItem.price = price
            newItem.availableCount = availableCount
            #if DEVELOPMENT
            newItem.imageURL = saveTemporaryImage(named: name)
            #else
            saveImage(named: name) { result in
                switch result {
                case .success(let url):
                    newItem.imageURL = url
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
            #endif
        }
        
        do {
            try PersistenceController.shared.saveContext()
            if item != nil {
                item = newItem
            }
            delegate?.refresh()
        } catch {
            print("Error saving context")
        }
    }
    
    func delete() {
        if let item = item {
            PersistenceController.shared.container.viewContext.delete(item)
            delegate?.refresh()
        }
    }
    
    private func saveTemporaryImage(named name: String) -> URL? {
        let temporaryDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        guard let imageName = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        let imageURL = temporaryDirectory.appendingPathComponent("\(imageName).jpeg")
        guard let data = self.image?.jpegData(compressionQuality: 0.5) else {
            return nil
        }
        do {
            try removeFiletIfExists(imageURL)
            try createFile(data, in: imageURL)
            return imageURL
        } catch {
            print("Error deleting image")
        }
        return nil
    }
    
    private func saveImage(named name: String, completion: @escaping (Result<URL, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {
                DispatchQueue.main.async {
                    completion(.failure(SaveImageError.invalidSelf))
                }
                return
            }
            // Get URL paths for iCloud Drive
            guard let iCloudDirectory = FileManager.iCloudDriveDirectory, let iCloudImageDirectory = FileManager.iCloudDriveImagesDirectory else {
                DispatchQueue.main.async {
                    completion(.failure(SaveImageError.invalidPath("iCloud Drive")))
                }
                return
            }
            // Convert image name to url format
            guard let imageName = name.urlEncoding else {
                DispatchQueue.main.async {
                    completion(.failure(SaveImageError.nameToURLFormat))
                }
                return
            }
            let imageURL = iCloudImageDirectory.appendingPathComponent("\(imageName).jpeg")
            // Convert image to JPEG data
            guard let data = self.image?.jpegCompressedData else {
                DispatchQueue.main.async {
                    completion(.failure(SaveImageError.jpegConversion))
                }
                return
            }
            // Create directories if necessary
            do {
                try self.createDirectoryIfNeeded(iCloudDirectory)
                try self.createDirectoryIfNeeded(iCloudImageDirectory)
                try self.removeFiletIfExists(imageURL)
                try self.createFile(data, in: imageURL)
                DispatchQueue.main.async {
                    print("Image saved in \(imageURL)")
                    completion(.success(imageURL))
                    return
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func createDirectoryIfNeeded(_ url: URL) throws {
        if (!FileManager.default.fileExists(atPath: url.path, isDirectory: nil)) {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    private func removeFiletIfExists(_ url: URL) throws {
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(atPath: url.path)
        }
    }
    
    private func createFile(_ data: Data, in url: URL) throws {
        try data.write(to: url)
    }
    
    private func returnImage(url: URL?, completion: @escaping (Result<URL?, Error>) -> Void) {
        DispatchQueue.main.async {
            completion(.success(url))
            return
        }
    }
}

class ValidatorConvertible: Equatable {
    static var required = RequiredValidator(tag: "required")
    var tag: String = ""
    init(tag: String) {
        self.tag = tag
    }
    func validate(_ value: String?) throws -> String {
        fatalError("Method `validate` has to be overriden")
    }
    static func == (lhs: ValidatorConvertible, rhs: ValidatorConvertible) -> Bool {
        return lhs.tag == rhs.tag
    }
}

//enum ValidatorType {
//    case required
//}
//
//enum ValidatorFactory {
//    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
//        switch type {
//        case .required: return RequiredValidator()
//        }
//    }
//}

class RequiredValidator: ValidatorConvertible {
    override func validate(_ value: String?) throws -> String {
        guard let value = value, !value.isEmpty else { throw ValidatorError.required }
        return value
    }
}

enum ValidatorError: Error {
    case required
}
