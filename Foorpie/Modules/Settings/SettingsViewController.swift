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
        title = "Settings"
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ButtonTableViewCell.self)
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
        cell.configure(with: "Cerrar Sesión", style: .default)
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GIDSignIn.sharedInstance()?.signOut()
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .overFullScreen
        present(loginViewController, animated: true)
    }
}
