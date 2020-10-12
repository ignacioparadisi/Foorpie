//
//  LoadingButton.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/12/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {
    
    private var title: String?
    private let activityIndicator = UIActivityIndicatorView()
    var activityIndicatorColor: UIColor? {
        didSet {
            if let color = activityIndicatorColor {
                activityIndicator.color = color
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(activityIndicator)
        activityIndicator.isHidden = true
        activityIndicator.anchor.centerToSuperview().activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoading() {
        title = currentTitle
        setTitle(nil, for: .normal)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        setTitle(title, for: .normal)
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        if let title = title {
            self.title = title
        }
    }
}
