//
//  PreferencesService.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 07/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation

public protocol PreferencesService: AnyObject {

    var lastUsedLine: String? { get set }
}
