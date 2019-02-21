//
//  UIViewController+Rx.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 08/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    func error(with title: String? = nil) -> Binder<Error> {
        return Binder(base) { vc, error in
            let alertTitle = title ?? NSLocalizedString("Error", comment: "")
            vc.presentError(title: alertTitle, error: error.localizedDescription)
        }
    }
}
