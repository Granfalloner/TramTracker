//
//  LocationService.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 07/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

public enum LocationServiceErrors: Error {
    case operationNotPermitted
}

public protocol LocationService {

    // MARK: - Authorization

    var authorizationStatus: Observable<CLAuthorizationStatus> { get }

    func requestAuthorization() // Requests full (always) access

    // MARK: - Monitoring

    var isMonitoringEnabled: Bool { get }

    var maximumMonitoringRadius: CLLocationDistance { get }

    var monitoredRegions: Observable<[CLCircularRegion]> { get }

    func startMonitoring(for region: CLCircularRegion) throws

    func getState(for region: CLCircularRegion) -> Observable<CLRegionState>

    func stopMonitoring(for region: CLCircularRegion)
}
