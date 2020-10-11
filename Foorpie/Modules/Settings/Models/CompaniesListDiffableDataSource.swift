//
//  CompaniesListDiffableDataSource.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/10/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class CompaniesListDiffableDataSource: UITableViewDiffableDataSource<CompaniesListViewModel.Section, CompanyViewModel> {
    private let viewModel: CompaniesListViewModel
    init(viewModel: CompaniesListViewModel, tableView: UITableView, cellProvider: @escaping UITableViewDiffableDataSource<CompaniesListViewModel.Section, CompanyViewModel>.CellProvider) {
        self.viewModel = viewModel
        super.init(tableView: tableView, cellProvider: cellProvider)
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel.canEditRow(at: indexPath)
    }
}
