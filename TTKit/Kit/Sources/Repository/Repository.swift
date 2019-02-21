//
//  Repository.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 07/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import RxSwift

public class Repository {

    // MARK: - Ivars

    let api: API

    // TODO: switch to Realm or CoreData underlying storage
    // TODO: add cache expiration handling
    var cache = [GetTimetableParams: Timetable]()

    // MARK: - Public

    public init(network: NetworkService) {
        api = API(network: network)
    }

    public func getStops() -> Observable<[Stop]> {
        // TODO: Stops should be fetched from some API as well
        guard let url = Bundle.main.url(forResource: "Stops", withExtension: "json") else { return .empty() }
        do {
            let data = try Data(contentsOf: url)
            let dict = try JSONDecoder().decode([String: [Stop]].self, from: data)
            guard let stops = dict["stops"] else { return .empty() }
            return Observable.just(stops).concat(Observable.never()) // Returns observable that will never terminate
        } catch {
            return .error(error)
        }
    }

    public func getTimetable(stopId: String, line: Int) -> Observable<Timetable> {
        let params = GetTimetableParams(stopId: stopId, line: line)
        if let timetable = cache[params] {
            return .just(timetable)
        } else {
            return api.timetable.get(params: params)
                .map { Timetable.createFromResponse($0) }
                .do(onNext: { [weak self] result in
                    self?.cache[params] = result
                })
        }
    }
}
