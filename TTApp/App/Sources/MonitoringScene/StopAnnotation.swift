//
//  StopAnnotation.swift
//  TramTracker
//
//  Created by Vasyl Myronchuk on 07/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import MapKit
import TTKit

class StopAnnotation: NSObject {

    // MARK: - Ivars

    let stop: Stop
    let isActive: Bool

    // MARK: - Public

    init(stop: Stop, isActive: Bool) {
        self.stop = stop
        self.isActive = isActive
    }
}

// MARK: - MKAnnotation

extension StopAnnotation: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
    }

    var title: String? {
        return stop.name
    }
}
