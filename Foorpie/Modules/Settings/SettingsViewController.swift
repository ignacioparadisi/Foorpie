//
//  SettingsViewController.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/21/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import GoogleSignIn

class SettingsViewController: BaseViewController {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as ButtonTableViewCell
        cell.configure(with: Localizable.Button.logout, style: .default)
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLogoutAlert()
    }
}
