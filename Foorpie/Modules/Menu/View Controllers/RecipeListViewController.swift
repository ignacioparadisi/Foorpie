//
//  RecipeListViewController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import MobileCoreServices

class RecipeListViewController: BaseViewController {
    
    // MARK: Properties
    /// TableView to display recipes in menu
    private let tableView: UITableView = UITableView()
    /// View model that contains the information for the view
    private let viewModel = RecipeListViewModel()
    /// Search controller to filter recipes by name
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: Functions
    override func setupView() {
        setupTableView()
        addErrorMessage()
        viewModel.fetch()
        tableView.reloadData()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = Localizable.Title.menu
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        navigationItem.setRightBarButtonItems([addButtonItem, editButtonItem], animated: false)
        setupSearchController()
    }
    
    override func setupViewModel() {
        viewModel.reloadData = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.errorHandler = { [weak self] message in
            self?.showErrorMessage(message)
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
        tableView.dragDelegate = self
        tableView.tableFooterView = UIView()
        tableView.register(RecipeTableViewCell.self)
        tableView.register(ButtonTableViewCell.self)
    }
    
    /// Configure the SearchBarController.
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Localizable.Text.search
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    /// Fetches the information and reloads the table view.
    @objc private func refresh() {
        tableView.refreshControl?.beginRefreshing()
        viewModel.fetch()
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    /// Sets tableView into edit mode when the edit button in the navigation bar is tapped
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    /// Present view controller for creating a new `Recipe`
    @objc private func addNewItem() {
        let detailViewModel = viewModel.detailForRow()
        let viewController = UINavigationController(rootViewController: RecipeDetailViewController(viewModel: detailViewModel))
        present(viewController, animated: true)
    }
    
}

// MARK: - UITableViewDataSource
extension RecipeListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.section(for: indexPath) == .ingredients {
            let cell = tableView.dequeueReusableCell(for: indexPath) as ButtonTableViewCell
            cell.configure(with: Localizable.Title.ingredients, image: .cartFill, style: .default, alignment: .natural)
            cell.accessoryType = .disclosureIndicator
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as RecipeTableViewCell
            cell.configure(with: viewModel.recipeForRow(at: indexPath))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel.section(for: indexPath) == .recipes
    }
    
}

// MARK: - UITableViewDelegate
extension RecipeListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteRecipe(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = viewModel.section(for: indexPath) else { return }
        switch section {
        case .recipes:
            let detailViewModel = viewModel.detailForRow(at: indexPath)
            let viewController = UINavigationController(rootViewController: RecipeDetailViewController(viewModel: detailViewModel))
            showDetailViewController(viewController, sender: nil)
        case .ingredients:
            let ingredientsViewController = IngredientListViewController()
            let viewController = UINavigationController(rootViewController: ingredientsViewController)
            showDetailViewController(viewController, sender: nil)
        }
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y < 0 else { return }
        let topSafeAreaHeight = view.safeAreaInsets.top
        if topSafeAreaHeight > abs(scrollView.contentOffset.y) {
            setErrorMessageTopAnchorConstant()
        } else {
            setErrorMessageTopAnchorConstant(abs(scrollView.contentOffset.y))
        }
    }
}

extension RecipeListViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return viewModel.dragItemForRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return viewModel.dragItemForRow(at: indexPath)
    }
}

// MARK: - UISearchResultsUpdating
extension RecipeListViewController: UISearchResultsUpdating {
    
    /// Updates the table view when the user is filtering the data
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filter(searchController.searchBar.text)
        tableView.reloadData()
    }
    
}


