//
//  Value.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 08/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation

public struct Value: Decodable {
    let key: String
    let value: String
}

public struct Values: Decodable {
    let values: [Value]
}
