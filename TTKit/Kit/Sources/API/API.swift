//
//  API.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 07/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation

public class API {

    static let baseUrl = URL(string: "https://api.um.warszawa.pl/api/action/")!

    static let appId = "e923fa0e-d96c-43f9-ae6e-60518c9f3238"
    static let apiKey = "77d85563-0c36-4e31-844b-de0671572312"

    // MARK: - Ivars

    var network: NetworkService

    public var baseUrl = API.baseUrl

    public var apiUrl: URL {
        return baseUrl
    }

    var defaultParameters: [String: Any] = ["id": API.appId,
                                            "apikey": API.apiKey]

    // MARK: - Public

    init(network: NetworkService) {
        self.network = network
    }
}
