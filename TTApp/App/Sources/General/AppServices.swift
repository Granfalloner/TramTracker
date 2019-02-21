//
//  AppServices.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 07/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import TTKit

class AppServices {

    static var shared = AppServices()

    // MARK: - Ivars

    fileprivate var network: NetworkService!
    fileprivate var location: LocationService!
    fileprivate var reachability: ReachabilityService!
    fileprivate var prefs: PreferencesService!

    fileprivate var repository: Repository!

    // MARK: - Public

    init() {
        network = createNetworkService()
        location = createLocationService()
        reachability = createReachabilityService()
        prefs = createPreferencesService()
        repository = Repository(network: network)
    }
}

// MARK: - ServiceFactory

extension AppServices: ServiceFactory {

    func createNetworkService() -> NetworkService {
        // Service configuration can be applied here
        return AlamofireNetworkService()
    }

    func createLocationService() -> LocationService {
        // Service configuration can be applied here
        return CoreLocationService()
    }

    func createReachabilityService() -> ReachabilityService {
        // Service configuration can be applied here
        return SCReachabilityService(with: "www.apple.com")!
    }

    func createPreferencesService() -> PreferencesService {
        // Service configuration can be applied here
        return UserDefaultsPreferencesService()
    }
}

// MARK: - Dependency injection

extension LocationServiceClient {
    var location: LocationService {
        return AppServices.shared.location
    }
}

extension ReachabilityServiceClient {
    var reachability: ReachabilityService {
        return AppServices.shared.reachability
    }
}

extension PreferencesServiceClient {
    var prefs: PreferencesService {
        return AppServices.shared.prefs
    }
}

extension RepositoryClient {
    var repository: Repository {
        return AppServices.shared.repository
    }
}
