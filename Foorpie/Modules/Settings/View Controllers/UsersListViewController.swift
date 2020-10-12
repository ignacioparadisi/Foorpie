//
//  UsersListViewController.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/11/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class UsersListViewController: BaseViewController {
    
    private let tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    private var dataSource: UsersListDiffableDataSource!
    private let viewModel: UsersListViewModel
    
    init(viewModel: UsersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        tableView.dataSource = dataSource
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.anchor.edgesToSuperview().activate()
        tableView.register(ButtonTableViewCell.self)
        tableView.register(TableViewCell.self)
        reloadData()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = LocalizedStrings.Title.users
    }
    
    override func setupViewModel() {
        super.setupViewModel()
        viewModel.didCreateInvitation = { [weak self] error in
            if let error = error {
                self?.showErrorAlert(message: error.localizedDescription)
                return
            }
            if let cell = self?.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) {
                self?.showActivityViewController(sourceView: cell)
            }
        }
        viewModel.didFetchUsers = { [weak self] error in
            if let error = error {
                self?.showErrorAlert(message: error.localizedDescription)
                return
            }
            self?.reloadData()
        }
    }
    
    override func setupDataSource() {
        dataSource = UsersListDiffableDataSource(viewModel: viewModel, viewController: self, tableView: tableView, cellProvider: { [weak self] tableView, indexPath, item in
            guard let section = self?.viewModel.section(for: indexPath) else { return nil }
            switch section {
            case .invite:
                guard let title = item as? String else { return nil }
                let cell = tableView.dequeueReusableCell(for: indexPath) as ButtonTableViewCell
                cell.configure(with: title, style: .filled, activityIndicatorColor: .white)
                return cell
            default:
                guard let user = item as? UserViewModel else { return nil }
                let cell = tableView.dequeueReusableCell(for: indexPath) as TableViewCell
                cell.textLabel?.text = user.fullName
                return cell
            }
        })
    }
    
    private func reloadData(animated: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<UsersListViewModel.Section, AnyHashable>()
        snapshot.appendSections([.invite, .users])
        snapshot.appendItems([LocalizedStrings.Button.inviteUser], toSection: .invite)
        snapshot.appendItems(viewModel.users, toSection: .users)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    private func showActivityViewController(sourceView: UIView) {
        let activityViewController = UIActivityViewController(activityItems: [viewModel], applicationActivities: nil)
        activityViewController.title = LocalizedStrings.Button.inviteUser
        activityViewController.popoverPresentationController?.sourceView = sourceView
        activityViewController.popoverPresentationController?.sourceRect = sourceView.bounds
        present(activityViewController, animated: true)
    }
}

extension UsersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = viewModel.section(for: indexPath) else { return }
        switch section {
        case .invite:
            if let cell = tableView.cellForRow(at: indexPath) as? ButtonTableViewCell {
                cell.startLoading()
            }
            viewModel.createInvitation()
        case .users:
            break
        }
    }
}
