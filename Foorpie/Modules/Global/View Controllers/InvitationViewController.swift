//
//  InvitationViewController.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/11/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

class InvitationViewController: BaseViewController {

    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold
        label.textAlignment = .center
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private let acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizedStrings.Button.acceptInvitation, for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    private let closeButton: UIButton = {
        let button = UIButton(type: .close)
        return button
    }()
    private let contentView = UIView()
    private let viewModel: InvitationViewModel
    private var loadingView = LoadingView(title: LocalizedStrings.Text.loading)
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: InvitationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        view.backgroundColor = .systemBackground
        view.addSubview(contentView)
        view.addSubview(acceptButton)
        view.addSubview(closeButton)
        setupInformationView()
        setupAcceptButton()
        setupCloseButton()
        viewModel.fetchInvitationInformation()
    }
    
    private func setupInformationView() {
        contentView.anchor
            .top(greaterOrEqual: closeButton.bottomAnchor, constant: 20)
            .leadingToSuperview(constant: 20, toSafeArea: true)
            .bottom(lessOrEqual: acceptButton.topAnchor, constant: -20)
            .trailingToSuperview(constant: -20, toSafeArea: true)
            .centerToSuperview()
            .activate()
        contentView.addSubview(companyNameLabel)
        contentView.addSubview(descriptionLabel)
        
        companyNameLabel.anchor
            .topToSuperview()
            .leadingToSuperview()
            .trailingToSuperview()
            .centerXToSuperview()
            .activate()
        
        descriptionLabel.anchor
            .top(to: companyNameLabel.bottomAnchor, constant: 10)
            .leadingToSuperview()
            .bottomToSuperview()
            .trailingToSuperview()
            .centerXToSuperview()
            .activate()
    }
    
    private func setupAcceptButton() {
        acceptButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        acceptButton.anchor
            .leadingToSuperview(constant: 20, toSafeArea: true)
            .bottomToSuperview(constant: -40, toSafeArea: true)
            .trailingToSuperview(constant: -20, toSafeArea: true)
            .height(constant: 44)
            .activate()
    }
    
    private func setupCloseButton() {
        closeButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        closeButton.anchor
            .topToSuperview(constant: 20, toSafeArea: true)
            .trailingToSuperview(constant: -20, toSafeArea: true)
            .activate()
    }
    
    override func setupViewModel() {
        viewModel.didFetchInvitation = { [weak self] error in
            if let error = error {
                self?.showErrorMessage(error.localizedDescription)
                return
            }
            self?.companyNameLabel.text = self?.viewModel.companyName ?? ""
            self?.descriptionLabel.text = String(format: LocalizedStrings.Message.invitationDetail, self?.viewModel.companyName ?? "")
        }
        viewModel.$isLoading
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    self.view.insertSubview(self.loadingView, belowSubview: self.closeButton)
                    self.loadingView.anchor.edgesToSuperview().activate()
                    self.loadingView.startAnimating()
                } else {
                    self.loadingView.stopAnimating { [weak self] _ in
                        self?.loadingView.removeFromSuperview()
                    }
                }
            }
            .store(in: &subscriptions)
    }
}
