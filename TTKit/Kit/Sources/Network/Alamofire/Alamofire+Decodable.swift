//
//  Alamofire+Decodable.swift
//  AKKit
//
//  Created by Vasyl Myronchuk on 10/12/2018.
//  Copyright © 2018 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import Alamofire

// Workaround for empty response
struct EmptyResponse: Decodable {}

extension Request {
    public static func serializeResponseDecodable<T: Decodable>(response: HTTPURLResponse?,
                                                                data: Data?, error: Error?) -> Result<T> {
        guard error == nil else { return .failure(error!) }

        guard let validData = data else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }

        if validData.isEmpty {
            if let emptyResponse = EmptyResponse() as? T { return .success(emptyResponse) }
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }

        do {
            let object = try JSONDecoder().decode(T.self, from: validData)
            return .success(object)
        } catch {
            return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
        }
    }
}

extension Request {
    public static func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponseDecodable(response: response, data: data, error: error)
        }
    }
}
