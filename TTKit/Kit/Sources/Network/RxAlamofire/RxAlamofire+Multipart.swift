//
//  RxAlamofire+Multipart.swift
//  AKKit
//
//  Created by Vasyl Myronchuk on 10/12/2018.
//  Copyright © 2018 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

extension Reactive where Base: SessionManager {
    func encodeMultipartUpload(to url: URLConvertible,
                               method: Alamofire.HTTPMethod = .post,
                               headers: HTTPHeaders? = nil,
                               data: @escaping (MultipartFormData) -> Void) -> Observable<UploadRequest> {
        return Observable.create { observer in
            self.base.upload(multipartFormData: data,
                             to: url,
                             method: method,
                             headers: headers) { (result: SessionManager.MultipartFormDataEncodingResult) in
                                switch result {
                                case .failure(let error):
                                    observer.onError(error)
                                case .success(let request, _, _):
                                    observer.onNext(request)
                                    observer.onCompleted()
                                }
            }

            return Disposables.create()
        }
    }
}
