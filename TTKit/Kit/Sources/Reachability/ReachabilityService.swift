//
//  ReachabilityService.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 07/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import RxSwift

public enum ReachabilityState {
    case notReachable
    case cellular
    case wifi(String?) // WiFi name
}

public enum ReachabilityServiceErrors: Error {
    case cannotStartService
}

public protocol ReachabilityService {

    init?(with host: String)
    var host: String { get }

    var state: Observable<ReachabilityState> { get }

    var isMonitoring: Bool { get }
    func startMonitoring() throws
    func stopMonitoring()
}
