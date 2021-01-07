//
//  FormViewController.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 12/1/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol FormFieldRepresentable {
    var stringValue: String? { get set }
}

class FormField<T: Equatable>: FormFieldRepresentable {
    var stringValue: String?
    var value: T?
    var placeholder: String?
    var title: String?
}

protocol Form {
    var fields: [FormFieldRepresentable] { get set }
}

class FormViewController: UIViewController {
    
    lazy var saveButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSaveButton))
    lazy var loadingBarActivityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
    lazy var loadingButtonItem = UIBarButtonItem(customView: loadingBarActivityIndicator)
    let tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    var fields: [[FieldViewModel]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TextFieldTableViewCell.self)
        tableView.register(CurrencyTextFieldTableViewCell.self)
        tableView.register(FloatTextFieldTableViewCell.self)
        tableView.register(ButtonTableViewCell.self)
        tableView.register(UnitTextFieldTableViewCell.self)
    }
    
    func setupNavigationBar() {
        
    }
    
    @objc func didTapSaveButton() {
    }
}

extension FormViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension FormViewController: UITableViewDelegate {
    
}
