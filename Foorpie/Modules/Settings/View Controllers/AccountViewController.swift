//
//  AccountViewController.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/21/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import GoogleSignIn
import Combine

class AccountViewController: BaseViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var dataSource: UITableViewDiffableDataSource<AccountViewModel.Section, String>!
    private let viewModel: AccountViewModel = AccountViewModel()
    private var subscriptions = Set<AnyCancellable>()
    private lazy var loadingView = LoadingView()

    override func setupView() {
        super.setupView()
        setupTableView()
        reloadData()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = Localizable.Title.profile
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(ButtonTableViewCell.self)
        tableView.register(ActivityIndicatorTableViewCell.self)
    }
    
    override func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<AccountViewModel.Section, String>(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, title in
            guard let self = self, let section = self.viewModel.section(for: indexPath) else {
                return nil
            }
            switch section {
            case .information:
                guard let row = self.viewModel.informationRow(for: indexPath) else { return nil }
                switch row {
                case .companies:
                    let cell = tableView.dequeueReusableCell(for: indexPath) as ActivityIndicatorTableViewCell
                    cell.configure(with: title, value: self.viewModel.companyName)
                    self.viewModel.$isLoadingCompanies
                        .assign(to: \.isLoading, on: cell)
                        .store(in: &self.subscriptions)
                    return cell
                case .users:
                    let cell = tableView.dequeueReusableCell(for: indexPath) as ActivityIndicatorTableViewCell
                    cell.configure(with: title)
                    self.viewModel.$isLoadingUsers
                        .assign(to: \.isLoading, on: cell)
                        .store(in: &self.subscriptions)
                    return cell
                }
                
            case .logout:
                let cell = tableView.dequeueReusableCell(for: indexPath) as ButtonTableViewCell
                cell.configure(with: title, style: .destructive)
                return cell
            }
        })
    }
    
    private func reloadData(animated: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<AccountViewModel.Section, String>()
        snapshot.appendSections([.information, .logout])
        snapshot.appendItems(viewModel.informationRowsTitle, toSection: .information)
        snapshot.appendItems([Localizable.Button.logout], toSection: .logout)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    override func setupViewModel() {
        viewModel.didFetchCompanies = { [weak self] companiesViewModel in
            let viewController = CompaniesListViewController(viewModel: companiesViewModel)
            let navigationController = UINavigationController(rootViewController: viewController)
            self?.showDetailViewController(navigationController, sender: self)
        }
        viewModel.didLogout = { [weak self] success in
            if success {
                self?.logout()
            } else {
                let alert = UIAlertController(title: "Logout Error", message: "There was an error logging out. Please try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: Localizable.Button.ok, style: .default, handler: nil)
                alert.addAction(okAction)
                self?.present(alert, animated: true)
            }
        }
        viewModel.$isLoggingOut
            .sink { [weak self] isLoggingOut in
                if isLoggingOut {
                    self?.view.isUserInteractionEnabled = false
                    self?.showLoadingView()
                } else {
                    self?.view.isUserInteractionEnabled = true
                    self?.loadingView.stopAnimating(completion: { _ in
                        self?.loadingView.removeFromSuperview()
                    })
                }
            }
            .store(in: &subscriptions)
        
        UserDefaults.standard
            .publisher(for: \.companyName)
            .sink { [weak self] _ in
                if self?.dataSource != nil {
                    self?.reloadData()
                }
            }
            .store(in: &subscriptions)
    }
    
    private func showLoadingView() {
        loadingView.setTitle("Logging out")
        navigationController?.view.addSubview(loadingView)
        loadingView.anchor.edgesToSuperview().activate()
        loadingView.startAnimating()
    }
    
    private func showLogoutAlert() {
        let alertController = UIAlertController(title: Localizable.Title.logoutQuestion, message: nil, preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: Localizable.Button.logout, style: .destructive) { [weak self] _ in
            self?.viewModel.logout()
        }
        let cancelAction = UIAlertAction(title: Localizable.Button.cancel, style: .cancel, handler: nil)
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func logout() {
        tabBarController?.selectedIndex = 0
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: true)
    }

}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = viewModel.section(for: indexPath) else { return }
        switch section {
        case .information:
            guard let row = viewModel.informationRow(for: indexPath) else { return }
            switch row {
            case .companies:
                viewModel.fetchCompanies()
            case .users:
                let viewModel = UsersListViewModel()
                let viewController = UsersListViewController(viewModel: viewModel)
                let navigationController = UINavigationController(rootViewController: viewController)
                showDetailViewController(navigationController, sender: self)
            }
            
        case .logout:
            showLogoutAlert()
        }
    }
}
