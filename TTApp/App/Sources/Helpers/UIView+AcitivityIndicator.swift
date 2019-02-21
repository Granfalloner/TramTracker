//
//  UIView+AcitivityIndicator.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 08/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var activityIndicator: UIActivityIndicatorView {
        guard let indicator = objc_getAssociatedObject(self, &kActivityIndicatorKey) as? UIActivityIndicatorView else {
            let indicator = createIndicator()
            objc_setAssociatedObject(self, &kActivityIndicatorKey, indicator, .OBJC_ASSOCIATION_RETAIN)
            return indicator
        }
        bringSubviewToFront(indicator)
        return indicator
    }

    func showActivity() {
        activityIndicator.startAnimating()
    }

    func hideActivity() {
        activityIndicator.stopAnimating()
    }

    // MARK: - Private

    private func createIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .gray)
        addSubview(indicator)
        indicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
        indicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin,
                                      .flexibleTopMargin, .flexibleBottomMargin]
        return indicator
    }
}

private var kActivityIndicatorKey: UInt8 = 0
