//
//  TimetableSceneProtocols.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 08/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import RxSwift
import TTKit

protocol TimetableViewProtocol: AnyObject {

    var loadCommand: Observable<Void> { get }
}

protocol TimetablePresenterProtocol {

    var timetable: Observable<Timetable> { get }

    var requestActive: Observable<Bool> { get }
    var requestError: Observable<Error> { get }

    var view: TimetableViewProtocol? { get set }
}
