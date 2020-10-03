//
//  CompaniesListViewController.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/1/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class CompaniesListViewController: BaseViewController {
    
    private var companies: [Company] = []
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var selectedCompany: Int? {
        return UserDefaults.standard.getSelectedCompany()?.id
    }
    
    init(companies: [Company]) {
        self.companies = companies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        title = "Companies"
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        var buttonItems = [addButtonItem]
        if companies.count > 1 {
            buttonItems.append(editButtonItem)
        }
        navigationItem.setRightBarButtonItems(buttonItems, animated: false)
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
}

extension CompaniesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let company = companies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = company.name
        if company.id == selectedCompany {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return companies.count > 1 ? .delete : .none
    }
}

extension CompaniesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && companies.count > 1 {
            
        }
    }
}
