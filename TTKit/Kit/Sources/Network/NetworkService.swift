//
//  NetworkService.swift
//  AKKit
//
//  Created by Vasyl Myronchuk on 10/12/2018.
//  Copyright © 2018 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - NetworkService protocol -

/// Public service encapsulating HTTP layer.
/// Private types will implement it using some dedicated library.
public protocol NetworkService {

    func request<T: Decodable, P: Encodable>(_ url: URL,
                                             _ method: HTTPMethod,
                                             headers: Headers?,
                                             params: P) -> Observable<(HTTPURLResponse, T)>

    func upload<T: Decodable>(_ url: URL,
                              _ method: HTTPMethod,
                              headers: Headers?,
                              body: BodyContent) -> Observable<(HTTPURLResponse, T)>

    func uploadMultipartFormData<T: Decodable>(_ url: URL,
                                               _ method: HTTPMethod,
                                               headers: Headers?,
                                               parts: [BodyPart]) -> Observable<(HTTPURLResponse, T)>

    // Headers

    var defaultHeaders: Headers { get set }
}

// MARK: - Default parameters & convenient methods -

public extension NetworkService {

    // MARK: - Request

    func request<T: Decodable>(_ url: URL,
                               _ method: HTTPMethod = .GET,
                               headers: Headers? = nil) -> Observable<(HTTPURLResponse, T)> {
        return request(url, method, headers: headers, params: EmptyParams())
    }

    func request<T: Decodable, P: Encodable>(_ url: URL,
                                             _ method: HTTPMethod = .GET,
                                             headers: Headers? = nil,
                                             params: P) -> Observable<(HTTPURLResponse, T)> {
        return request(url, method, headers: headers, params: params)
    }

    // MARK: - Upload

    func upload<T: Decodable>(_ url: URL,
                              _ method: HTTPMethod = .PUT,
                              headers: Headers? = nil,
                              body: BodyContent) -> Observable<(HTTPURLResponse, T)> {
        return upload(url, method, headers: headers, body: body)
    }

    // MARK: - Multipart upload

    public func uploadMultipartFormData<T: Decodable>(_ url: URL,
                                                      _ method: HTTPMethod = .POST,
                                                      headers: Headers? = nil,
                                                      resourceUrl: URL,
                                                      name: String,
                                                      filename: String? = nil,
                                                      mimeType: String? = nil) -> Observable<(HTTPURLResponse, T)> {
        let part = BodyPart(url: resourceUrl, name: name, filename: filename, mimeType: mimeType)
        return uploadMultipartFormData(url, method, headers: headers, parts: [part])
    }

    public func uploadMultipartFormData<T: Decodable>(_ url: URL,
                                                      _ method: HTTPMethod = .POST,
                                                      headers: Headers? = nil,
                                                      parts: [BodyPart]) -> Observable<(HTTPURLResponse, T)> {
        return uploadMultipartFormData(url, method, headers: headers, parts: parts)
    }

    // MARK: - Headers

    mutating func addDefaultHeader(_ header: Headers.Element) {
        var headers = defaultHeaders
        headers[header.key] = header.value
        defaultHeaders = headers
    }

    mutating func removeDefaultHeader(for key: Headers.Key) {
        var headers = defaultHeaders
        headers.removeValue(forKey: key)
        defaultHeaders = headers
    }
}
