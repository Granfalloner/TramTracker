//
//  Observable+Validation.swift
//  AKKit
//
//  Created by Vasyl Myronchuk on 10/12/2018.
//  Copyright © 2018 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

extension Observable where E: DataRequest {
    func validate(_ range: Range<Int> = 200..<300) -> Observable<E> {
        return map { $0.validate() }
    }
}
