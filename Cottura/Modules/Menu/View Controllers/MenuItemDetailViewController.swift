//
//  MenuItemDetailViewController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    // MARK: Properties
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let viewModel: MenuItemDetailViewModel
    enum Section: Int, CaseIterable {
        case photo
        case fields
        case delete
    }
    
    // MARK: Initializers
    init(viewModel: MenuItemDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        title = viewModel.title
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotoPickerTableViewCell.self)
        tableView.register(TextFieldTableViewCell.self)
        tableView.register(ButtonTableViewCell.self)
    }

}

extension MenuItemDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .photo:
            let cell = tableView.dequeueReusableCell(for: indexPath) as PhotoPickerTableViewCell
            cell.configure(with: UIImage(named: "pizza"))
            return cell
        case .fields:
            let cell = tableView.dequeueReusableCell(for: indexPath) as TextFieldTableViewCell
            return cell
        case .delete:
            let cell = tableView.dequeueReusableCell(for: indexPath) as ButtonTableViewCell
            return cell
        }
    }
}

extension MenuItemDetailViewController: UITableViewDelegate {
    
}
