//
//  MenuItemDetailViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

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
            saveImage(named: name) { url in
                newItem.imageURL = url
            }
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
    
    private func saveImage(named name: String, completion: @escaping (URL?) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else {
                DispatchQueue.main.async {
                    completion(nil)
                    return
                }
                return
            }
            guard let iCloudDirectory = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {
                self.returnImage(url: nil, completion: completion)
                return
            }
            if (!FileManager.default.fileExists(atPath: iCloudDirectory.path, isDirectory: nil)) {
                do {
                    try FileManager.default.createDirectory(at: iCloudDirectory, withIntermediateDirectories: true, attributes: nil)
                }
                catch {
                    //Error handling
                    print("Error in creating doc")
                }
            }
            let iCloudImageDirectory = iCloudDirectory.appendingPathComponent("Images")
            if (!FileManager.default.fileExists(atPath: iCloudImageDirectory.path, isDirectory: nil)) {
                do {
                    try FileManager.default.createDirectory(at: iCloudImageDirectory, withIntermediateDirectories: true, attributes: nil)
                }
                catch {
                    //Error handling
                    print("Error in creating doc")
                }
            }
            guard let imageName = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                self.returnImage(url: nil, completion: completion)
                return
            }
            let imageURL = iCloudImageDirectory.appendingPathComponent("\(imageName).jpeg")
            guard let data = self.image?.jpegData(compressionQuality: 0.5) else {
                self.returnImage(url: nil, completion: completion)
                return
            }
            if FileManager.default.fileExists(atPath: imageURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: imageURL.path)
                } catch {
                    print("Error deleting image")
                }
            }
            
            do {
                try data.write(to: imageURL)
                DispatchQueue.main.async {
                    self.returnImage(url: imageURL, completion: completion)
                    return
                }
            } catch {
                print(error.localizedDescription)
                print("Error saving image")
            }
           self.returnImage(url: nil, completion: completion)
        }
    }
    
    private func returnImage(url: URL?, completion: @escaping (URL?) -> Void) {
        DispatchQueue.main.async {
            completion(url)
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
