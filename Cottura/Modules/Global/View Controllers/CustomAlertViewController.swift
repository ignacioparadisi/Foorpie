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
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
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
        imageView.tintColor = .systemGreen
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
        
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 100, weight: .semibold)
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
    
    var alertView: AlertView!
    private var timer: Timer?
    private let dismissAfter: Double
    
    init(title: String, message: String, style: AlertView.Style, dismiss after: Double = 2.0) {
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
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(alertView)
        alertView.backgroundColor = .systemBackground
        alertView.anchor
            .centerToSuperview()
            .top(greaterOrEqual: view.safeAreaLayoutGuide.topAnchor, constant: 20)
            .trailing(lessOrEqual: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            .bottom(lessOrEqual: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            .leading(greaterOrEqual: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
            .width(greaterThanOrEqualToConstant: 200)
            .activate()
        alertView.layer.cornerRadius = 15
        
        alertView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissView() {
        dismiss(animated: true) {
            self.timer?.invalidate()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.2) {
            self.alertView.transform = CGAffineTransform.identity
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval() + dismissAfter, repeats: false) { timer in
            self.dismiss(animated: true) {
                timer.invalidate()
            }
        }
    }
    
}
