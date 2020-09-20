//
//  IngredientDetailViewController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class IngredientDetailViewController: BaseViewController {
    
    // MARK: Properties
    private let viewModel: IngredientDetailViewModel
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var saveButtonItem: UIBarButtonItem?
    
    // MARK: Initializers
    init(viewModel: IngredientDetailViewModel = IngredientDetailViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationController?.navigationBar.prefersLargeTitles = false
        title = viewModel.title
        if !viewModel.isEditing {
            let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
            navigationItem.leftBarButtonItem = closeButtonItem
        }
        saveButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
        navigationItem.rightBarButtonItem = saveButtonItem
    }
    
    override func setupView() {
        super.setupView()
        setupTableView()
    }
    
    // MARK: Functions
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TextFieldTableViewCell.self)
        tableView.register(CurrencyTextFieldTableViewCell.self)
        tableView.register(FloatTextFieldTableViewCell.self)
        tableView.register(ButtonTableViewCell.self)
        tableView.register(UnitTextFieldTableViewCell.self)
    }
    
    @objc private func dismissView() {
        dismiss(animated: true)
    }

}

// MARK: - UITableViewDataSource
extension IngredientDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = viewModel.section(for: indexPath) else { return UITableViewCell() }
        switch section {
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
            case .float:
                let cell = tableView.dequeueReusableCell(for: indexPath) as FloatTextFieldTableViewCell
                cell.configure(with: field as! FloatTextFieldCellViewModel)
                return cell
            case .unit:
                let cell = tableView.dequeueReusableCell(for: indexPath) as UnitTextFieldTableViewCell
                cell.configure(with: field as! UnitTextFieldCellViewModel)
                cell.delegate = self
                return cell
            default:
                return UITableViewCell()
            }
        case .delete:
            let cell = tableView.dequeueReusableCell(for: indexPath) as ButtonTableViewCell
            cell.configure(with: Localizable.Button.delete, style: .destructive)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Esta información se utiliza para calcular el precio bruto de cada receta. El precio introducido debe ser el costo de las unidades ingresadas."
    }
}

// MARK: - UITableViewDelegate
extension IngredientDetailViewController: UITableViewDelegate {
    
}

extension IngredientDetailViewController: UnitTextFieldTableViewCellDelegate {
    func presentSheet(_ alert: UIAlertController) {
        present(alert, animated: true)
    }
}
