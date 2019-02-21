//
//  BaseParams.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 07/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation

public class BaseParams: Encodable {
    let id: String = API.appId
    let apikey: String = API.apiKey
}
