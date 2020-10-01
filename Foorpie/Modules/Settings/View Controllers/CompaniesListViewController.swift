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
    
    init(companies: [Company]) {
        self.companies = companies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
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
        return cell
    }
}

extension CompaniesListViewController: UITableViewDelegate {
    
}
