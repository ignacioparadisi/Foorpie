//
//  UsersListDiffableDataSource.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/11/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class UsersListDiffableDataSource: UITableViewDiffableDataSource<UsersListViewModel.Section, String> {
    private let viewModel: UsersListViewModel
    private let viewController: UsersListViewController
    init(viewModel: UsersListViewModel, viewController: UsersListViewController, tableView: UITableView, cellProvider: @escaping UITableViewDiffableDataSource<UsersListViewModel.Section, String>.CellProvider) {
        self.viewModel = viewModel
        self.viewController = viewController
        super.init(tableView: tableView, cellProvider: cellProvider)
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
        }
    }
}
