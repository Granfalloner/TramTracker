//
//  TimetablePresenter.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 08/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt
import TTKit

class TimetablePresenter: RepositoryClient, ReachabilityServiceClient {

    // MARK: - Ivars

    var stop: Stop
    var lineNumber: Int

    weak var view: TimetableViewProtocol? {
        didSet { setup() }
    }

    private var responses = Observable<Event<Timetable>>.never()
    private let bag = DisposeBag()

    // MARK: - Public

    init(stop: Stop, lineNumber: Int) {
        self.stop = stop
        self.lineNumber = lineNumber
    }
}

// MARK: - TimetablePresenterProtocol

extension TimetablePresenter: TimetablePresenterProtocol {

    var requestActive: Observable<Bool> {
        guard let view = view else { return .never() }
        return Observable.merge(view.loadCommand.map { true },
                                responses.map { _ in false })
            .startWith(false)
    }

    var timetable: Observable<Timetable> {
        return responses.map { $0.element }.unwrap()
    }

    var requestError: Observable<Error> {
        return responses.map { $0.error }.unwrap()
    }
}

// MARK: - Private

private extension TimetablePresenter {
    func setup() {
        guard let view = view else { return }

        // TODO: Utilize Reachability service feedback
        do {
            try reachability.startMonitoring()
        } catch {
            /// - TODO: error reporting
        }

        reachability.state
            .debug()
            .subscribe()
            .disposed(by: bag)

        responses = view.loadCommand
            .flatMapLatest { [repository, stop, lineNumber] in
                repository.getTimetable(stopId: stop.stopId, line: lineNumber).materialize()
            }
    }
}
