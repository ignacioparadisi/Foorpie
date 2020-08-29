//
//  OrderPlateCollectionViewCell.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class OrderPlateCollectionViewCell: UICollectionViewCell, ReusableView, NibLoadableView {

    @IBOutlet private weak var dishImageView: UIImageView!
    @IBOutlet private weak var statusButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var availabilityLabel: UILabel!
    @IBOutlet private weak var availabilityStepper: UIStepper!
    @IBOutlet private weak var priceLabel: UILabel!
    private var isReady = false
    private var availableCount: Int = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceLabel.font = UIFont.preferredFont(forTextStyle: .title2).bold
        statusButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote).bold
        availabilityStepper.value = Double(availableCount)
    }

    @IBAction func didTapStatusButton(_ sender: UIButton) {
        isReady.toggle()
        statusButton.backgroundColor = isReady ? .systemGreen : .systemGray3
    }
    @IBAction func stepperValueDidChange(_ sender: UIStepper) {
        availabilityLabel.text = "\(Int(sender.value))"
        priceLabel.text = "$\(7 * sender.value)"
    }
}
