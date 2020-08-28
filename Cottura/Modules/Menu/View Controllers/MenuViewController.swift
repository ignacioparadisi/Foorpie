//
//  MenuViewController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {
    
    // MARK: Properties
    /// TableView to display dishes in menu
    private let tableView: UITableView = UITableView()
    /// View model that contains the information for the view
    private let viewModel = MenuViewModel()
    /// Search controller to filter dishes by name
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: Functions
    override func setupView() {
        setupTableView()
        viewModel.fetch()
        tableView.reloadData()
    }
    
    override func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Menú"
        let addBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewItem))
        navigationItem.setRightBarButtonItems([addBarButton, editButtonItem], animated: false)
        setupSearchController()
    }
    
    override func setupViewModel() {
           viewModel.reloadData = { [weak self] in
               self?.tableView.reloadData()
           }
       }
    
    /// Add tableview to the view configure the table view and register cells.
    private func setupTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(DishTableViewCell.self)
    }
    
    /// Configure the SearchBarController.
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    /// Fetches the information and reloads the table view.
    @objc private func refresh() {
        viewModel.fetch()
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    /// Sets tableView into edit mode when the edit button in the navigation bar is tapped
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    /// Present view controller for creating a new `Dish`
    @objc private func addNewItem() {
        let detailViewModel = viewModel.detailForRow()
        let viewController = UINavigationController(rootViewController: DishDetailViewController(viewModel: detailViewModel))
        present(viewController, animated: true)
    }
    
}

// MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as DishTableViewCell
        cell.configure(with: viewModel.dishForRow(at: indexPath))
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteDish(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewModel = viewModel.detailForRow(at: indexPath)
        let viewController = UINavigationController(rootViewController: DishDetailViewController(viewModel: detailViewModel))
        showDetailViewController(viewController, sender: nil)
    }
}

// MARK: - UISearchResultsUpdating
extension MenuViewController: UISearchResultsUpdating {
    
    /// Updates the table view when the user is filtering the data
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filter(searchController.searchBar.text)
        tableView.reloadData()
    }
    
}


