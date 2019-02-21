//
//  API.Timetable.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 07/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire

public extension API {
    struct Timetable {
        private let api: API

        init(api: API) {
            self.api = api
        }
    }

    var timetable: Timetable {
        return Timetable(api: self)
    }
}

// MARK: - API calls

public extension API.Timetable {
    func get(params: GetTimetableParams) -> Observable<TimetableResponse> {
        return api.network.request(api.apiUrl.appendingPathComponent("dbtimetable_get"),
                                   .GET,
                                   headers: nil,
                                   params: params)
            .map { $0.1 }
    }
}
