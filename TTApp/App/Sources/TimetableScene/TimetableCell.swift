//
//  TimetableCell.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 08/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import UIKit
import TTKit

class TimetableCell: UITableViewCell {

    // MARK: - Ivars

    var model: TimeEntry? {
        didSet { updateUI() }
    }

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!

    // MARK: - Overrides

    override func prepareForReuse() {
        super.prepareForReuse()
        model = nil
    }
}

// MARK: - Private

private extension TimetableCell {
    func updateUI() {
        hourLabel.text = model?.hour

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        model?.minutes.forEach { minutes in
            let label = UILabel()
            label.textColor = .timetableTint
            label.text = minutes
            stackView.addArrangedSubview(label)
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        }
    }
}
