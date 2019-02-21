//
//  MonitoringPresenter.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 07/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import TTKit

class MonitoringPresenter: LocationServiceClient, PreferencesServiceClient, RepositoryClient {

    // MARK: - Ivars

    weak var view: MonitoringViewProtocol? {
        didSet { setup() }
    }

    private let bag = DisposeBag()
}

// MARK: - MonitoringPresenterProtocol

extension MonitoringPresenter: MonitoringPresenterProtocol {
    var locationEnabled: Observable<Bool> {
        return location.authorizationStatus.map { $0 == .authorizedAlways || $0 == .authorizedWhenInUse }
    }

    var enableLocationTitle: Observable<String> {
        return location.authorizationStatus
            .map { status in
                switch status {
                case .notDetermined: return NSLocalizedString("Enable", comment: "")
                case .denied, .restricted: return NSLocalizedString("Go to Settings", comment: "")
                case .authorizedWhenInUse, .authorizedAlways: return ""
                }
            }
    }

    var stops: Observable<[Stop]> {
        return repository.getStops()
    }
}

// MARK: - Private

private extension MonitoringPresenter {
    func setup() {
        guard let view = view else { return }

        // TODO: Add preferences handling
        
        view.enableLocation
            .withLatestFrom(location.authorizationStatus)
            .subscribe(onNext: { [weak self] status in
                self?.handleEnableLocation(status)
            })
            .disposed(by: bag)
    }

    func handleEnableLocation(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
        case .denied, .restricted:
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        case .notDetermined:
            location.requestAuthorization()
        }
    }
}
