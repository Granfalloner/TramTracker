//
//  AlamofireNetworkService.swift
//  AKKit
//
//  Created by Vasyl Myronchuk on 10/12/2018.
//  Copyright © 2018 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire
import MobileCoreServices

/// Concrete implementation of *NetworkService* using Alamofire.
public class AlamofireNetworkService: NetworkService {

    public var defaultHeaders: Headers = [:]

    // MARK: - Data request

    public func request<T: Decodable, P: Encodable>(_ url: URL,
                                                    _ method: HTTPMethod,
                                                    headers: Headers?,
                                                    params: P) -> Observable<(HTTPURLResponse, T)> {
        let method = alamofireMethodFrom(method)
        if method == .get || method == .delete {
            do {
                // Quirk to convert Encodable to [String: Any] as Alamofire expects
                let encodedParams = try JSONEncoder().encode(params)
                let decodedParams = try JSONSerialization.jsonObject(with: encodedParams)
                guard let paramsDict = decodedParams as? [String: Any] else { throw ParametersError.dictionaryExpected }

                let combinedHeaders = mergedHeaders(headers)
                return SessionManager.default.rx.request(method, url, parameters: paramsDict, headers: combinedHeaders)
                    .validate()
                    .flatMap { $0.rx.responseDecodable() }
            } catch {
                return Observable.error(error)
            }
        } else {
            let combinedHeaders = mergedHeaders(headers)
            let request = EncodableRequest(url: url, method: method, headers: combinedHeaders, params: params)
            return SessionManager.default.rx.request(urlRequest: request)
                .validate()
                .flatMap { $0.rx.responseDecodable() }
        }
    }

    // MARK: - Upload

    public func upload<T: Decodable>(_ url: URL,
                                     _ method: HTTPMethod,
                                     headers: Headers?,
                                     body: BodyContent) -> Observable<(HTTPURLResponse, T)> {
        do {
            let response: Observable<UploadRequest>
            let combinedHeaders = mergedHeaders(headers)
            let urlRequest = try URLRequest(url: url, method: alamofireMethodFrom(method), headers: combinedHeaders)

            switch body {
            case .url(let url): response = SessionManager.default.rx.upload(url, urlRequest: urlRequest)
            case .data(let data): response = SessionManager.default.rx.upload(data, urlRequest: urlRequest)
            }

            return response
                .validate()
                .flatMap { $0.rx.responseDecodable() }
        } catch {
            return Observable.error(error)
        }
    }

    // MARK: - Multipart upload

    public func uploadMultipartFormData<T: Decodable>(_ url: URL,
                                                      _ method: HTTPMethod,
                                                      headers: Headers?,
                                                      parts: [BodyPart]) -> Observable<(HTTPURLResponse, T)> {
        let method = alamofireMethodFrom(method)
        let combinedHeaders = mergedHeaders(headers)
        return SessionManager.default.rx
            .encodeMultipartUpload(to: url, method: method, headers: combinedHeaders) { multipartFormData in
                parts.forEach { self.add(bodyPart: $0, to: multipartFormData) }
            }
            .validate()
            .flatMap { $0.rx.responseDecodable() }
    }

    public init() {
    }
}

// MARK: - Private -

private extension AlamofireNetworkService {

    func alamofireMethodFrom(_ httpMethod: HTTPMethod) -> Alamofire.HTTPMethod {
        switch httpMethod {
        case .GET: return .get
        case .POST: return .post
        case .PUT: return .put
        case .DELETE: return .delete
        }
    }

    func mimeType(forPathExtension pathExtension: String) -> String {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                          pathExtension as CFString, nil)?.takeRetainedValue(),
            let contentType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
            return contentType as String
        }

        return "application/octet-stream"
    }

    func add(bodyPart part: BodyPart, to multipartFormData: MultipartFormData) {
        switch part.content {
        case .url(let url):
            let filename = part.filename ?? url.lastPathComponent
            let mimeType = part.mimeType ?? self.mimeType(forPathExtension: url.pathExtension)
            multipartFormData.append(url, withName: part.name, fileName: filename, mimeType: mimeType)

        case .data(let data):
            if let mimeType = part.mimeType {
                if let filename = part.filename {
                    multipartFormData.append(data, withName: part.name, fileName: filename, mimeType: mimeType)
                } else {
                    multipartFormData.append(data, withName: part.name, mimeType: mimeType)
                }
            } else {
                multipartFormData.append(data, withName: part.name)
            }
        }
    }

    func mergedHeaders(_ headers: Headers?) -> Headers {
        return defaultHeaders.merging(headers ?? [:]) { _, new in new }
    }
}
