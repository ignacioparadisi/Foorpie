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
    /// Sections in the Table View
    enum Section: Int, CaseIterable {
        case photo
        case fields
        case delete
    }
    
    /// Table View to display the fields
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    /// Image picker for the dish image
    private let imagePicker = UIImagePickerController()
    /// View model that contains the dish information
    private let viewModel: DishDetailViewModel
    /// Navigation bar button for saving the dish
    private var saveBarButton: UIBarButtonItem!
    /// Set for storing combine subscriptions
    private var subscriptions = Set<AnyCancellable>()
    
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
    }
    
    /// Setup the Navigation Bar with title and buttons
    private func setupNavigationBar() {
        title = viewModel.title
        saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveBarButton
        if !viewModel.isEditing {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        }
    }

    /// Add the Table View into the view and register cells
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
    
    /// Implement all view model closures and subscriptions
    private func setupViewModel() {
        viewModel.refresh = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.readyToSubmit
            .assign(to: \.isEnabled, on: saveBarButton)
            .store(in: &subscriptions)
    }
    
    /// Save dish information
    @objc private func save() {
        viewModel.save()
        if viewModel.isEditing {
            showSuccessAlert()
        }
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        dismissView()
    }
    
    /// Dismiss view
    /// - Parameter didDelete: Whether the user is deleting the dish or not
    @objc private func dismissView(didDelete: Bool = false) {
        if !viewModel.isEditing {
            dismiss(animated: true)
        } else if didDelete {
            navigationController?.navigationController?.popViewController(animated: true)
        }
    }
    
    /// Show alert with image picker options
    /// - Parameter sender: The cell that triggered the event
    private func showImagePickerAlert(sender: PhotoPickerTableViewCell) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if viewModel.image != nil {
            alertController.addAction(title: Localizable.Button.resetPhoto, style: .destructive, image: .trash) { [weak self] _ in
               self?.viewModel.clearImage()
            }
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(title: Localizable.Button.takePhoto, style: .default, image: .camera) { [weak self] _ in
               self?.presentImagePicker(sourceType: .camera)
            }
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alertController.addAction(title: Localizable.Button.choosePhoto, style: .default, image: .photoOnRectangle) { [weak self] _ in
               self?.presentImagePicker(sourceType: .photoLibrary)
            }
        }
        alertController.addAction(title: Localizable.Button.cancel, style: .cancel)
        if let popoverController = alertController.popoverPresentationController {
            sender.setPopoverController(popoverController)
        }
        present(alertController, animated: true)
    }
    
    /// Presents the image picker on screen
    /// - Parameter sourceType: Type of picker to show (Camera or Gallery)
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        imagePicker.isModalInPresentation = true
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    /// Show delete confirmation alert
    private func showDeleteAlert() {
        let alertController = UIAlertController(title: String(format:Localizable.Title.delete, viewModel.title), message: Localizable.Message.deleteDish, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: Localizable.Button.delete, style: .destructive) { _ in
            self.viewModel.delete()
            if self.splitViewController?.viewControllers.count == 2 {
                self.splitViewController?.viewControllers[1] = NoItemSelectedViewController.noDishSelected
            } else {
                self.dismissView()
            }
        }
        let cancelAction = UIAlertAction(title: Localizable.Button.cancel, style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    /// Presents a success alert
    private func showSuccessAlert() {
        showAlert(title: Localizable.Title.saved, message: Localizable.Message.savedDish, style: .success)
    }

}

// MARK: - UITableViewDataSource
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
            cell.configure(with: Localizable.Button.delete, style: .destructive)
            return cell
        }
    }
    
}

// MARK: - UITableViewDelegate
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

// MARK: - UIImagePickerControllerDelegate
extension DishDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        viewModel.image = image
        viewModel.imageDidChange = true
        tableView.reloadRows(at: [IndexPath(row: 0, section: Section.photo.rawValue)], with: .automatic)
    }
    
}
