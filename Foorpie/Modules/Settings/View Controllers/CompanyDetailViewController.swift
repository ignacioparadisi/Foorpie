//
//  CompanyDetailViewController.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/3/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class CompanyDetailViewController: BaseFormViewController {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "Company"
        navigationItem.rightBarButtonItem = saveButtonItem
    }
    
    override func setupView() {
        super.setupView()
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
    }
    
    override func didTapSaveButton() {
        navigationItem.rightBarButtonItem = loadingButtonItem
        loadingBarActivityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loadingBarActivityIndicator.stopAnimating()
            self.navigationItem.rightBarButtonItem = self.saveButtonItem
        }
    }
    
}
