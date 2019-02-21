//
//  StopOverlay.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 07/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import MapKit
import TTKit

class StopOverlay: MKCircle {

    static let radiusThreshold: CLLocationDistance = 50

    // MARK: - Ivars

    private(set) var stop: Stop!
    private(set) var isActive = false

    // MARK: - Overrides

    convenience init(stop: Stop, isActive: Bool) {
        let coord = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
        self.init(center: coord, radius: StopOverlay.radiusThreshold)
        self.stop = stop
        self.isActive = isActive
    }
}
