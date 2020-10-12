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
        label.numberOfLines = 0
        return label
    }()
    private let acceptButton: LoadingButton = {
        let button = LoadingButton()
        button.setTitle(LocalizedStrings.Button.acceptInvitation, for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 10
        button.activityIndicatorColor = .white
        return button
    }()
    private let closeButton: UIButton = {
        let button = UIButton(type: .close)
        return button
    }()
    private let companyLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "building.columns.fill")
        imageView.tintColor = .systemGray4
        imageView.contentMode = .scaleAspectFit
        return imageView
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
            .leading(greaterOrEqual: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
            .bottom(lessOrEqual: acceptButton.topAnchor, constant: -20)
            .trailing(lessOrEqual: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            .centerToSuperview()
            .width(lessThanOrEqualToConstant: 400)
            .activate()
        
        contentView.addSubview(companyLogoImageView)
        contentView.addSubview(companyNameLabel)
        contentView.addSubview(descriptionLabel)
        
        companyLogoImageView.anchor
            .topToSuperview()
             .leading(greaterOrEqual: contentView.leadingAnchor)
             .trailing(greaterOrEqual: contentView.trailingAnchor)
            .centerXToSuperview()
            .height(to: companyLogoImageView.widthAnchor)
            .width(lessThanOrEqualToConstant: 300)
            .activate()
        
        companyNameLabel.anchor
            .top(to: companyLogoImageView.bottomAnchor, constant: 20)
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
        acceptButton.addTarget(self, action: #selector(acceptInvitation), for: .touchUpInside)
        acceptButton.anchor
            .leading(greaterOrEqual: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
            .bottomToSuperview(constant: -40, toSafeArea: true)
            .trailing(lessOrEqual: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            .height(constant: 44)
            .width(greaterThanOrEqualToConstant: 400)
            .centerXToSuperview()
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
                if let apiError = error as? APIService.APIError {
                    if apiError.localizedDescription == "This invitation is no longer valid" {
                        self?.companyLogoImageView.image = UIImage(systemName: "clock.arrow.circlepath")
                        self?.companyLogoImageView.tintColor = .systemOrange
                        self?.companyNameLabel.text = LocalizedStrings.Title.invitationExpired
                        self?.descriptionLabel.text = LocalizedStrings.Message.invitationExpired
                        self?.acceptButton.isHidden = true
                        return
                    }
                }
                self?.showErrorAlert(message: error.localizedDescription)
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
        viewModel.$isAcceptingInvitation
            .map { !$0 }
            .assign(to: \.isEnabled, on: acceptButton)
            .store(in: &subscriptions)
        viewModel.$isAcceptingInvitation
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.acceptButton.startLoading()
                } else {
                    self?.acceptButton.stopLoading()
                }
            }
            .store(in: &subscriptions)
        viewModel.didAcceptInvitation = { [weak self] error in
            if let error = error {
                self?.showErrorAlert(message: error.localizedDescription)
            } else {
                self?.showAlert(title: "Bienvenido", message: "Has sido agregado a la compañía", style: .success, completion: {
                    self?.dismiss(animated: true)
                })
                
            }
        }
    }
    
    @objc private func acceptInvitation() {
        viewModel.acceptInvitation()
    }
}
