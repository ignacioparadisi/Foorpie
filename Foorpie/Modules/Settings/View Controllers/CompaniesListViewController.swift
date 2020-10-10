//
//  CompaniesListViewController.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/1/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class CompaniesListViewController: BaseViewController {
    
    private var dataSource: UITableViewDiffableDataSource<CompaniesListViewModel.Section, CompanyViewModel>!
    private let viewModel: CompaniesListViewModel
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    init(viewModel: CompaniesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        title = "Companies"
        configureDataSource()
        tableView.delegate = self
        tableView.dataSource = dataSource
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        updateList()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateCompany))
        var buttonItems = [addButtonItem]
        if viewModel.canEdit {
            buttonItems.append(editButtonItem)
        }
        navigationItem.setRightBarButtonItems(buttonItems, animated: false)
        
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
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<CompaniesListViewModel.Section, CompanyViewModel>(tableView: tableView, cellProvider: { tableView, indexPath, company in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
            cell.textLabel?.text = company.name
            cell.accessoryType = company.isSelected ? .checkmark : .none
            return cell
        })
    }
    
    private func updateList(animated: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<CompaniesListViewModel.Section, CompanyViewModel>()
        snapshot.appendSections([.companies])
        snapshot.appendItems(viewModel.companiesViewModels, toSection: .companies)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

extension CompaniesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && viewModel.canEdit {
            
        }
    }
}
