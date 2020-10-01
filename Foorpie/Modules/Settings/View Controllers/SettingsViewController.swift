//
//  SettingsViewController.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/21/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import GoogleSignIn
import Combine

class SettingsViewController: BaseViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let viewModel: SettingsViewModel = SettingsViewModel()
    private var subscriptions = Set<AnyCancellable>()

    override func setupView() {
        super.setupView()
        setupTableView()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = Localizable.Title.settings
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ButtonTableViewCell.self)
        tableView.register(ActivityIndicatorTableViewCell.self)
    }
    
    override func setupViewModel() {
        viewModel.didFetchCompanies = { [weak self] companies in
            let viewController = CompaniesListViewController(companies: companies)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func showLogoutAlert() {
        let alertController = UIAlertController(title: Localizable.Title.logoutQuestion, message: nil, preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: Localizable.Button.logout, style: .destructive) { [weak self] _ in
            self?.logout()
        }
        let cancelAction = UIAlertAction(title: Localizable.Button.cancel, style: .cancel, handler: nil)
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func logout() {
        GIDSignIn.sharedInstance()?.signOut()
        tabBarController?.selectedIndex = 0
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: true)
    }

}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = viewModel.section(for: indexPath) else {
            return UITableViewCell()
        }
        switch section {
        case .companies:
            let cell = tableView.dequeueReusableCell(for: indexPath) as ActivityIndicatorTableViewCell
            cell.configure(with: "Companies")
            viewModel.$isLoadingCompanies
                .assign(to: \.isLoading, on: cell)
                .store(in: &subscriptions)
            return cell
        case .logout:
            let cell = tableView.dequeueReusableCell(for: indexPath) as ButtonTableViewCell
            cell.configure(with: Localizable.Button.logout, style: .default)
            return cell
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = viewModel.section(for: indexPath) else { return }
        switch section {
        case .companies:
            viewModel.fetchCompanies()
        case .logout:
            showLogoutAlert()
        }
    }
}
