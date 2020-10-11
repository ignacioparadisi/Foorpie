//
//  CompaniesListViewController.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/1/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

class CompaniesListViewController: BaseViewController {
    
    private var dataSource: UITableViewDiffableDataSource<CompaniesListViewModel.Section, CompanyViewModel>!
    private let viewModel: CompaniesListViewModel
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private lazy var loadingView = LoadingView(title: Localizable.Text.loading)
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: CompaniesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        tableView.delegate = self
        tableView.dataSource = dataSource
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        tableView.register(TableViewCell.self)
        reloadData()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "Companies"
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCreateCompanyAlert))
        var buttonItems = [addButtonItem]
        if viewModel.canEdit {
            buttonItems.append(editButtonItem)
        }
        navigationItem.setRightBarButtonItems(buttonItems, animated: false)
    }
    
    override func setupViewModel() {
        super.setupViewModel()
        viewModel.$isLoading
            .sink { [weak self] isLoading in
                guard let self = self else { return }
//                if isLoading {
//                    self.view.addSubview(self.loadingView)
//                    self.loadingView.anchor.edgesToSuperview().activate()
//                    self.loadingView.startAnimating()
//                } else {
//                    self.loadingView.stopAnimating { [weak self] _ in
//                        self?.loadingView.removeFromSuperview()
//                    }
//                }
            }
            .store(in: &subscriptions)
        
        viewModel.didSaveCompany = { [weak self] success in
            if success {
                self?.reloadData(animated: true)
            }
        }
        
        viewModel.didDeleteCompany = { [weak self] in
            self?.reloadData(animated: true)
        }
    }
    
    override func setupDataSource() {
        dataSource = CompaniesListDiffableDataSource(viewModel: viewModel, tableView: tableView, cellProvider: { tableView, indexPath, company in
            let cell = tableView.dequeueReusableCell(for: indexPath) as TableViewCell
            cell.textLabel?.text = company.name
            cell.accessoryType = company.isSelected ? .checkmark : .none
            return cell
        })
    }
    
    private func reloadData(animated: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<CompaniesListViewModel.Section, CompanyViewModel>()
        snapshot.appendSections([.companies])
        snapshot.appendItems(viewModel.companies, toSection: .companies)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    @objc func goToCreateCompany() {
        let viewController = CompanyDetailViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
    
    @objc func showCreateCompanyAlert() {
        let alert = UIAlertController(title: "Create Company", message: "Please enter the name of the company", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: Localizable.Button.save, style: .default, handler: { [weak alert, weak self] _ in
            guard let textField = alert?.textFields?[0], let name = textField.text else { return }
            self?.viewModel.saveCompany(named: name)
            alert?.dismiss(animated: true)
        })
        let cancelAction = UIAlertAction(title: Localizable.Button.cancel, style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = Localizable.Text.name
        }
        present(alert, animated: true)
    }
    
}

// MARK: - UITableViewDelegate
extension CompaniesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCompany(at: indexPath)
        reloadData()
    }
    
}
