//
//  PhotoPickerTableViewCell.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol PhotoPickerTableViewCellDelegate: class {
    func imageDidChange(_ image: UIImage?)
}

class PhotoPickerTableViewCell: UITableViewCell, ReusableView {
    
    // MARK: Properties
    private let selectImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote).bold
        button.setImage(.cameraFill, for: .normal)
        button.layer.cornerRadius = 22
        return button
    }()
    private var dropInteraction: UIDropInteraction!
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
    /// Add the components into the view
    private func setup() {
        dropInteraction = UIDropInteraction(delegate: self)
        self.addInteraction(dropInteraction)
        selectionStyle = .none
        if let imageView = imageView {
            imageView.anchor
                .edgesToSuperview()
                .width(to: contentView.widthAnchor)
                .height(to: imageView.widthAnchor)
                .activate()
        }
        contentView.addSubview(selectImageButton)
        
        selectImageButton.anchor
            .bottomToSuperview(constant: -16)
            .trailingToSuperview(constant: -16)
            .height(constant: 44)
            .width(constant: 44)
            .activate()
        
        selectImageButton.isUserInteractionEnabled = false
    }
    
    /// Add a new image to the image view
    /// - Parameter image: Image to be displayed
    func configure(with image: UIImage?) {
        if let image = image {
            imageView?.image = image
            imageView?.contentMode = .scaleAspectFill
        } else {
            imageView?.image = UIImage.photo?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
            imageView?.contentMode = .scaleAspectFit
        }
    }
    
    /// Sets a popover view to the `selectImageButton`
    /// - Parameter popoverController: PopoverController to be shown
    func setPopoverController(_ popoverController: UIPopoverPresentationController) {
        popoverController.sourceView = selectImageButton
        popoverController.sourceRect = selectImageButton.bounds
        popoverController.permittedArrowDirections = .down
    }
    
}

extension PhotoPickerTableViewCell: UIDropInteractionDelegate {
    // Defines if an element can be drop or not. In this case we make sure to only drop one image.
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: [kUTTypeImage as String]) && session.items.count == 1
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: self)
        let operation: UIDropOperation!
        if self.frame.contains(dropLocation) {
            operation = .copy
        } else {
            operation = .cancel
        }
        return UIDropProposal(operation: operation)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) { [weak self] imageItems in
            guard let images = imageItems as? [UIImage] else { return }
            self?.imageView?.image = images.first
            self?.delegate?.imageDidChange(images.first)
        }
    }
}
