//
//  Alamofire+Encodable.swift
//  AKKit
//
//  Created by Vasyl Myronchuk on 10/12/2018.
//  Copyright © 2018 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import Alamofire

// Workaround for empty parameters
struct EmptyParams: Encodable {}

struct EncodableRequest<P: Encodable> {
    let url: URLConvertible
    let method: Alamofire.HTTPMethod
    let headers: HTTPHeaders?
    let params: P
}

extension EncodableRequest: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        var urlRequest = try URLRequest(url: url, method: method, headers: headers)

        let encoder = JSONEncoder()
        do {
            if !(params is EmptyParams) {
                let encodedParams = try encoder.encode(params)
                urlRequest.httpBody = encodedParams
            }

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }

        return urlRequest
    }
}
