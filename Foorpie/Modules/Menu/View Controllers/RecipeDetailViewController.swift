//
//  RecipeDetailViewController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

class RecipeDetailViewController: UIViewController {
    
    // MARK: Properties
    
    /// Table View to display the fields
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    /// Image picker for the recipe image
    private let imagePicker = UIImagePickerController()
    /// View model that contains the recipe information
    private let viewModel: RecipeDetailViewModel
    /// Navigation bar button for saving the recipe
    private var saveBarButton: UIBarButtonItem!
    /// Set for storing combine subscriptions
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: Initializers
    init(viewModel: RecipeDetailViewModel = RecipeDetailViewModel()) {
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }
    
    /// Implement all view model closures and subscriptions
    private func setupViewModel() {
        viewModel.refresh = { [weak self] section in
            if let section = section {
                self?.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            } else {
                self?.tableView.reloadData()
            }
        }
        viewModel.readyToSubmit
            .assign(to: \.isEnabled, on: saveBarButton)
            .store(in: &subscriptions)
    }
    
    /// Save recipe information
    @objc private func save() {
        viewModel.save()
        if viewModel.isEditing {
            showSuccessAlert()
        }
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        dismissView()
    }
    
    /// Dismiss view
    /// - Parameter didDelete: Whether the user is deleting the recipe or not
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
            alertController.addAction(title: LocalizedStrings.Button.resetPhoto, style: .destructive, image: .trash) { [weak self] _ in
               self?.viewModel.clearImage()
            }
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(title: LocalizedStrings.Button.takePhoto, style: .default, image: .camera) { [weak self] _ in
               self?.presentImagePicker(sourceType: .camera)
            }
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alertController.addAction(title: LocalizedStrings.Button.choosePhoto, style: .default, image: .photoOnRectangle) { [weak self] _ in
               self?.presentImagePicker(sourceType: .photoLibrary)
            }
        }
        alertController.addAction(title: LocalizedStrings.Button.cancel, style: .cancel)
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
        let alertController = UIAlertController(title: String(format:LocalizedStrings.AlertTitle.delete, viewModel.title), message: LocalizedStrings.AlertMessage.deleteRecipe, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: LocalizedStrings.Button.delete, style: .destructive) { _ in
            self.viewModel.delete()
            if self.splitViewController?.viewControllers.count == 2 {
                self.splitViewController?.viewControllers[1] = NoItemSelectedViewController.noRecipeSelected
            } else {
                self.dismissView()
            }
        }
        let cancelAction = UIAlertAction(title: LocalizedStrings.Button.cancel, style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    /// Presents a success alert
    private func showSuccessAlert() {
        showAlert(title: LocalizedStrings.AlertTitle.saved, message: LocalizedStrings.AlertMessage.savedRecipe, style: .success)
    }

}

// MARK: - UITableViewDataSource
extension RecipeDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = viewModel.section(at: indexPath) else { return UITableViewCell() }
        switch section {
        case .photo:
            let cell = tableView.dequeueReusableCell(for: indexPath) as PhotoPickerTableViewCell
            cell.configure(with: viewModel.image)
            cell.delegate = self
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
            default:
                return UITableViewCell()
            }
        case .ingredients:
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
            cell.textLabel?.text = viewModel.ingredientsForRow(at: indexPath)
            return cell
        case .delete:
            let cell = tableView.dequeueReusableCell(for: indexPath) as ButtonTableViewCell
            cell.configure(with: LocalizedStrings.Button.delete, style: .destructive)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let section = viewModel.section(at: indexPath) else { return false }
        return section == .ingredients || section == .recipes
    }
    
}

// MARK: - UITableViewDelegate
extension RecipeDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = viewModel.section(at: indexPath) else { return }
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
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate
extension RecipeDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        viewModel.image = image
        viewModel.imageDidChange = true
        tableView.reloadRows(at: [IndexPath(row: 0, section: RecipeDetailViewModel.Section.photo.rawValue)], with: .automatic)
    }
    
}

extension RecipeDetailViewController: PhotoPickerTableViewCellDelegate {
    func imageDidChange(_ image: UIImage?) {
        viewModel.image = image
        viewModel.imageDidChange = true
    }
}
