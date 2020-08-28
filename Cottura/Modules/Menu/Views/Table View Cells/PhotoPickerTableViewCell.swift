//
//  PhotoPickerTableViewCell.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol PhotoPickerTableViewCellDelegate: class {
    func selectImage(sender: UIButton)
}

class PhotoPickerTableViewCell: UITableViewCell, ReusableView {
    
    // MARK: Properties
    private let selectImageButton = UIButton()
    weak var delegate: PhotoPickerTableViewCellDelegate?
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: Functions
    private func setup() {
        setupView()
    }
    
    private func setupView() {
        if let imageView = imageView {
            imageView.anchor
                .edgesToSuperview()
                .width(to: contentView.widthAnchor)
                .height(to: imageView.widthAnchor)
                .activate()
        }
        contentView.addSubview(selectImageButton)
        selectImageButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        selectImageButton.tintColor = .white
        selectImageButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote).bold
        selectImageButton.setTitle("Seleccionar Imagen", for: .normal)
        selectImageButton.layer.cornerRadius = 22
        selectImageButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        selectImageButton.anchor
            .bottomToSuperview(constant: -16)
            .trailingToSuperview(constant: -16)
            .height(constant: 44)
            .activate()
        
        selectImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
    }
    
    func configure(with image: UIImage?) {
        if let image = image {
            imageView?.image = image
            imageView?.contentMode = .scaleAspectFill
        } else {
            imageView?.image = UIImage(systemName: "photo")?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
            imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @objc func selectImage() {
        delegate?.selectImage(sender: selectImageButton)
    }
    
}
