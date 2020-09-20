//
//  IngredientListViewController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class IngredientListViewController: BaseViewController {
    
    // MARK: - Properties
    private var tableView: UITableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let viewModel = IngredientListViewModel()
    
    // MARK: - Functions
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = Localizable.Title.ingredients
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewIngredientView))
        navigationItem.setRightBarButtonItems([addButtonItem, editButtonItem], animated: false)
        setupSearchController()
    }
    
    override func setupView() {
        super.setupView()
        setupTableView()
        viewModel.fetch()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(IngredientTableViewCell.self)
    }
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Localizable.Text.search
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    @objc private func showNewIngredientView() {
        let controller = IngredientDetailViewController()
        present(UINavigationController(rootViewController: controller), animated: true)
    }
}

extension IngredientListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as IngredientTableViewCell
        cell.textLabel?.text = viewModel.text(for: indexPath)
        return cell
    }
}

extension IngredientListViewController: UITableViewDelegate {
    
}

// MARK: - UISearchResultsUpdating
extension IngredientListViewController: UISearchResultsUpdating {
    
    /// Updates the table view when the user is filtering the data
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filter(searchController.searchBar.text)
    }
    
}
