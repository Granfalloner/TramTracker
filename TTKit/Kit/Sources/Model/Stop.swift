//
//  Stop.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 07/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation

public struct Stop: Codable, Equatable {
    public let stopId: String
    public let name: String
    public let line: String
    public let direction: String
    public let latitude: Double
    public let longitude: Double

    enum CodingKeys: String, CodingKey {
        case stopId
        case name
        case line
        case direction
        case latitude = "lat"
        case longitude = "lon"
    }
}
