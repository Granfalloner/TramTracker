//
//  ServiceFactory.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 07/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import TTKit

/// Simple service factory
protocol ServiceFactory {

    func createNetworkService() -> NetworkService

    func createLocationService() -> LocationService

    func createReachabilityService() -> ReachabilityService

    func createPreferencesService() -> PreferencesService
}
