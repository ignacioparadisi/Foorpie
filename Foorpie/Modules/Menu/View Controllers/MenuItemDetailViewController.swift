//
//  DishDetailViewController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

class DishDetailViewController: UIViewController {
    // MARK: Properties
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let imagePicker = UIImagePickerController()
    private let viewModel: DishDetailViewModel
    private var saveBarButton: UIBarButtonItem!
    private var subscriptions = Set<AnyCancellable>()
    enum Section: Int, CaseIterable {
        case photo
        case fields
        case delete
    }
    
    // MARK: Initializers
    init(viewModel: DishDetailViewModel = DishDetailViewModel()) {
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
        setupViewModel()
        viewModel.readyToSubmit
            .assign(to: \.isEnabled, on: saveBarButton)
            .store(in: &subscriptions)
    }
    
    private func setupNavigationBar() {
        title = viewModel.title
        saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
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
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(PhotoPickerTableViewCell.self)
        tableView.register(TextFieldTableViewCell.self)
        tableView.register(CurrencyTextFieldTableViewCell.self)
        tableView.register(IntTextFieldTableViewCell.self)
        tableView.register(ButtonTableViewCell.self)
    }
    
    private func setupViewModel() {
        viewModel.refresh = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc private func save() {
        viewModel.save()
        if viewModel.isEditing {
            let controller = CustomAlertViewController(title: "Guardado", message: "El artículo se guardó de manera exitosa.", style: .success)
            self.present(controller, animated: true)
        }
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        dismissView()
    }
    
    @objc private func dismissView(didDelete: Bool = false) {
        if !viewModel.isEditing {
            dismiss(animated: true)
        } else if didDelete {
            navigationController?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func showImagePickerAlert(sender: PhotoPickerTableViewCell) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if viewModel.image != nil {
            let clearAction = UIAlertAction(title: "Restablecer Foto", style: .destructive) { [weak self] _ in
                self?.viewModel.clearImage()
            }
            clearAction.setValue(UIImage(systemName: "trash"), forKey: "image")
            alertController.addAction(clearAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Tomar Foto", style: .default) { [weak self] _ in
                self?.presentImagePicker(sourceType: .camera)
            }
            cameraAction.setValue(UIImage(systemName: "camera"), forKey: "image")
            alertController.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let galleryAction = UIAlertAction(title: "Seleccionar Foto", style: .default, handler: { [weak self] _ in
                self?.presentImagePicker(sourceType: .photoLibrary)
            })
            galleryAction.setValue(UIImage(systemName: "photo.on.rectangle"), forKey: "image")
            alertController.addAction(galleryAction)
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            sender.setPopoverController(popoverController)
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
    
    private func showDeleteAlert() {
        let alertController = UIAlertController(title: "¿Eliminar \"\(viewModel.title)\"?", message: "Al eliminar, no podrás agregar este producto a tus órdenes", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Eliminar", style: .destructive) { _ in
            self.viewModel.delete()
            if self.splitViewController?.viewControllers.count == 2 {
                self.splitViewController?.viewControllers[1] = NoItemSelectedViewController.menuDishController
            } else {
                self.dismissView()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

}

extension DishDetailViewController: UITableViewDataSource {
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

extension DishDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .photo:
            if let cell = tableView.cellForRow(at: indexPath) as? PhotoPickerTableViewCell {
                showImagePickerAlert(sender: cell)
            }
        case .fields:
            let cell = tableView.cellForRow(at: indexPath)
            cell?.becomeFirstResponder()
        case .delete:
            showDeleteAlert()
        }
    }
}

extension DishDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        viewModel.image = image
        viewModel.imageDidChange = true
        tableView.reloadRows(at: [IndexPath(row: 0, section: Section.photo.rawValue)], with: .automatic)
    }
}
