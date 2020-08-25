//
//  MenuViewController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    /// TableView to display items in menu
    private let tableView: UITableView = UITableView()
    private let viewModel = MenuViewModel()
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        viewModel.fetch()
        tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Menú"
        let addBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewItem))
        navigationItem.setRightBarButtonItems([addBarButton, editButtonItem], animated: false)
        setupSearchController()
    }
    
    private func setupTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MenuItemTableViewCell.self)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @objc private func refresh() {
        viewModel.fetch()
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    @objc private func addNewItem() {
        let viewController = UINavigationController(rootViewController: MenuItemDetailViewController())
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
        let cell = tableView.dequeueReusableCell(for: indexPath) as MenuItemTableViewCell
        cell.configure(with: viewModel.itemForRow(at: indexPath))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteItem(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewModel = viewModel.detailForRow(at: indexPath)
        let viewController = UINavigationController(rootViewController: MenuItemDetailViewController(viewModel: detailViewModel))
        showDetailViewController(viewController, sender: nil)
    }
}

// MARK: - UISearchResultsUpdating
extension MenuViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filter(searchController.searchBar.text)
        tableView.reloadData()
    }
}


