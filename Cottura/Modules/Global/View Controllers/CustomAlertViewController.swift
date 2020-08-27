//
//  CustomAlertViewController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/26/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class AlertView: UIView {
    enum Style {
        case success
        case error
        case none
    }
    private let contentMargin: CGFloat = 30
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3).bold
        label.textColor = .systemDarkGray
        label.textAlignment = .center
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemDarkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    init(title: String?, message: String?, style: Style = .none) {
        super.init(frame: .zero)
        setup(title: title, message: message, style: style)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup(title: String? = nil, message: String? = nil, style: Style = .none) {
        layer.cornerRadius = 15
        clipsToBounds = true
        let blurEffect = UIBlurEffect(style: .systemThickMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        imageView.anchor
            .topToSuperview(constant: contentMargin)
            .leading(greaterOrEqual: leadingAnchor, constant: contentMargin)
            .trailing(greaterOrEqual: trailingAnchor, constant: -contentMargin)
            .centerXToSuperview()
            .width(constant: 100)
            .height(to: imageView.widthAnchor)
            .activate()
        titleLabel.anchor
            .top(to: imageView.bottomAnchor, constant: 10)
            .leadingToSuperview(constant: contentMargin)
            .trailingToSuperview(constant: -contentMargin)
            .activate()
        descriptionLabel.anchor
            .top(to: titleLabel.bottomAnchor, constant: 5)
            .leadingToSuperview(constant: contentMargin)
            .trailingToSuperview(constant: -contentMargin)
            .bottomToSuperview(constant: -contentMargin)
            .activate()
        
        titleLabel.text = title
        descriptionLabel.text = message
        
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 100, weight: .medium)
        switch style {
        case .none:
            imageView.image = nil
            imageView.anchor.height(constant: 0).activate()
        case .success:
            imageView.image = UIImage(systemName: "checkmark.circle", withConfiguration: symbolConfiguration)
            imageView.tintColor = .systemGreen
        case .error:
            imageView.image = UIImage(systemName: "xmark.circle", withConfiguration: symbolConfiguration)
            imageView.tintColor = .systemRed
        }
    }
}

class CustomAlertViewController: UIViewController {
    
    private var backgroundView: UIView = UIView()
    private var alertView: AlertView!
    private var timer: Timer?
    private let dismissAfter: Double?
    
    init(title: String, message: String, style: AlertView.Style, dismiss after: Double? = 1.5) {
        dismissAfter = after
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        alertView = AlertView(title: title, message: message, style: style)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
        view.addSubview(backgroundView)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        backgroundView.anchor.edgesToSuperview().activate()
        
        view.addSubview(alertView)
        alertView.anchor
            .centerToSuperview()
            .top(greaterOrEqual: view.safeAreaLayoutGuide.topAnchor, constant: 20)
            .trailing(lessOrEqual: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            .bottom(lessOrEqual: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            .leading(greaterOrEqual: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
            .width(greaterThanOrEqualToConstant: 200)
            .width(lessThanOrEqualToConstant: 300)
            .activate()
        alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissView() {
        dismiss(animated: true) {
            self.timer?.invalidate()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAlert()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let dismissAfter = dismissAfter {
            timer = Timer.scheduledTimer(withTimeInterval: TimeInterval() + dismissAfter, repeats: false) { _ in
                self.hideAlert()
            }
        }
    }
    
    private func showAlert() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 8, options: .curveEaseInOut, animations: {
            self.alertView.transform = CGAffineTransform.identity
        })
    }
    
    private func hideAlert() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 8, options: .curveEaseInOut, animations: {
            self.alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.alertView.alpha = 0
        })
        self.dismiss(animated: true) {
            self.timer?.invalidate()
        }
    }
    
}
