//
//  UIViewController+Misc.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 08/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func presentError(title: String, error: String, handler: (() -> Void)? = nil) {
        let okTitle = NSLocalizedString("OK", comment: "")
        let okAction = UIAlertAction(title: okTitle, style: .cancel, handler: { _ in handler?() })

        let alertVC = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alertVC.addAction(okAction)

        present(alertVC, animated: true)
    }
}
