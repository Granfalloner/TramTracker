//
//  MultipartFormData.swift
//  AKKit
//
//  Created by Vasyl Myronchuk on 10/12/2018.
//  Copyright © 2018 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import RxSwift

public struct BodyPart {
    public let name: String
    public let filename: String?
    public let mimeType: String?
    public let content: BodyContent

    public init(url: URL, name: String, filename: String? = nil, mimeType: String? = nil) {
        self.content = .url(url)
        self.name = name
        self.filename = filename
        self.mimeType = mimeType
    }

    public init(data: Data, name: String, filename: String? = nil, mimeType: String? = nil) {
        self.content = .data(data)
        self.name = name
        self.filename = filename
        self.mimeType = mimeType
    }

    public init<T: Encodable>(value: T, name: String, filename: String? = nil, mimeType: String? = nil) throws {
        let data = try JSONEncoder().encode(value)
        self.init(data: data, name: name, filename: filename, mimeType: mimeType)
    }
}
