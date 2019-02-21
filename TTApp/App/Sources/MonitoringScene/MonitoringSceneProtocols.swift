//
//  MonitoringSceneProtocols.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 07/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import TTKit

protocol MonitoringViewProtocol: AnyObject {

    var longitude: Observable<CLLocationDegrees> { get }
    var latitude: Observable<CLLocationDegrees> { get }

    var enableLocation: Observable<Void> { get }
}

protocol MonitoringPresenterProtocol {

    var locationEnabled: Observable<Bool> { get }
    var enableLocationTitle: Observable<String> { get }

    var stops: Observable<[Stop]> { get }

    var view: MonitoringViewProtocol? { get set }
}
