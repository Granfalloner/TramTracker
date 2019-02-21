//
//  RxAlamofire+Decodable.swift
//  AKKit
//
//  Created by Vasyl Myronchuk on 10/12/2018.
//  Copyright © 2018 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

extension Reactive where Base: DataRequest {
    public func responseDecodable<T: Decodable>() -> Observable<(HTTPURLResponse, T)> {
        return responseResult(responseSerializer: Base.decodableResponseSerializer())
    }
}
