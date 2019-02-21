//
//  UIView+Rx.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 08/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    var backgroundColor: Binder<UIColor> {
        return Binder(self.base) { view, color in
            view.backgroundColor = color
        }
    }

    var isActive: Binder<Bool> {
        return Binder(self.base) { view, shouldAnimate in
            shouldAnimate ? view.showActivity() : view.hideActivity()
        }
    }
}
