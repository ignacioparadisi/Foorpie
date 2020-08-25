//
//  MenuItemDetailViewController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

class MenuItemDetailViewController: UIViewController {
    // MARK: Properties
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let imagePicker = UIImagePickerController()
    private let viewModel: MenuItemDetailViewModel
    private var saveBarButton: UIBarButtonItem!
    private var subscriptions = Set<AnyCancellable>()
    enum Section: Int, CaseIterable {
        case photo
        case fields
        case delete
    }
    
    // MARK: Initializers
    init(viewModel: MenuItemDetailViewModel = MenuItemDetailViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        viewModel.readyToSubmit
            .assign(to: \.isEnabled, on: saveBarButton)
            .store(in: &subscriptions)
    }
    
    private func setupNavigationBar() {
        title = viewModel.title
        saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = saveBarButton
        if !viewModel.isEditing {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        }
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotoPickerTableViewCell.self)
        tableView.register(TextFieldTableViewCell.self)
        tableView.register(CurrencyTextFieldTableViewCell.self)
        tableView.register(IntTextFieldTableViewCell.self)
        tableView.register(ButtonTableViewCell.self)
    }
    
    @objc private func dismissView() {
        if viewModel.isEditing {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    private func showGalleryAlert(sender: UITableViewCell?) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let galleryAction = UIAlertAction(title: "Galería", style: .default, handler: { [weak self] _ in
                self?.presentImagePicker(sourceType: .photoLibrary)
            })
            galleryAction.setValue(UIImage(systemName: "photo.on.rectangle"), forKey: "image")
            alertController.addAction(galleryAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Cámara", style: .default, handler: { [weak self] _ in
                self?.presentImagePicker(sourceType: .camera)
            })
            cameraAction.setValue(UIImage(systemName: "camera"), forKey: "image")
            alertController.addAction(cameraAction)
        }
        let clearAction = UIAlertAction(title: "Quitar Imagen", style: .destructive, handler: nil)
        clearAction.setValue(UIImage(systemName: "trash"), forKey: "image")
        alertController.addAction(clearAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if let popover = alertController.popoverPresentationController, let sender = sender {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
        }
        
        present(alertController, animated: true)
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        imagePicker.isModalInPresentation = true
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }

}

extension MenuItemDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .photo:
            let cell = tableView.dequeueReusableCell(for: indexPath) as PhotoPickerTableViewCell
            cell.configure(with: viewModel.image)
            return cell
        case .fields:
            let field = viewModel.fieldForRow(at: indexPath)
            switch field.type {
            case .textField:
                let cell = tableView.dequeueReusableCell(for: indexPath) as TextFieldTableViewCell
                cell.configure(with: field as! TextFieldCellViewModel)
                return cell
            case .currency:
                let cell = tableView.dequeueReusableCell(for: indexPath) as CurrencyTextFieldTableViewCell
                cell.configure(with: field as! CurrencyTextFieldCellViewModel)
                return cell
            case .integer:
                let cell = tableView.dequeueReusableCell(for: indexPath) as IntTextFieldTableViewCell
                cell.configure(with: field as! IntTextFieldCellViewModel)
                return cell
            }
        case .delete:
            let cell = tableView.dequeueReusableCell(for: indexPath) as ButtonTableViewCell
            cell.configure(with: "Eliminar", style: .destructive)
            return cell
        }
    }
}

extension MenuItemDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .photo:
            showGalleryAlert(sender: tableView.cellForRow(at: indexPath))
        case .fields:
            let cell = tableView.cellForRow(at: indexPath)
            cell?.becomeFirstResponder()
        case .delete:
            break
        }
    }
}

extension MenuItemDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        viewModel.image = image
        tableView.reloadRows(at: [IndexPath(row: 0, section: Section.photo.rawValue)], with: .automatic)
    }
}
