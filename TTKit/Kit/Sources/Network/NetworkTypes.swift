//
//  NetworkTypes.swift
//  AKKit
//
//  Created by Vasyl Myronchuk on 10/12/2018.
//  Copyright © 2018 Vasyl Myronchuk. All rights reserved.
//

import Foundation

// MARK: - Helper declarations -

public typealias Headers = [String: String]

public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

public enum BodyContent {
    case url(URL)
    case data(Data)
}

public enum ParametersError: Error {
    case dictionaryExpected
    case wrongJSONFormat
}
