//
//  DependencyInjection.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 07/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import TTKit

// Very simple explicit dependency injection scheme based on protocol conformances.
// Just conform to protocol, and dependency will be injected automatically

// MARK: - LocationServiceClient

protocol LocationServiceClient {
    var location: LocationService { get }
}

protocol ReachabilityServiceClient {
    var reachability: ReachabilityService { get }
}

protocol PreferencesServiceClient {
    var prefs: PreferencesService { get }
}

protocol RepositoryClient {
    var repository: Repository { get }
}
