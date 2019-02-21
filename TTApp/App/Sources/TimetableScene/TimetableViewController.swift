//
//  TimetableViewController.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 08/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import TTKit

class TimetableViewController: UITableViewController {

    // MARK: - Ivars

    var stop: Stop?
    var lineNumber: Int?

    private var presenter: TimetablePresenterProtocol!
    private let bag = DisposeBag()

    // MARK: - Overrides

    override func viewDidLoad() {
        setupUI()
        setupPresenter()
        bindPresenter()
    }

    // MARK: - Actions

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - TimetableViewProtocol

extension TimetableViewController: TimetableViewProtocol {
    var loadCommand: Observable<Void> {
        return Observable.just(()).concat(Observable.never())
    }
}

// MARK: - Private

private extension TimetableViewController {
    func setupUI() {
        navigationItem.title = stop?.name

        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.tableFooterView = UIView()
    }

    func setupPresenter() {
        guard let stop = stop, let lineNumber = lineNumber else {
            fatalError("Must provide stop and lineNumber")
        }

        presenter = TimetablePresenter(stop: stop, lineNumber: lineNumber)
        presenter.view = self
    }

    func bindPresenter() {
        presenter.requestActive
            .bind(to: tableView.rx.isActive)
            .disposed(by: bag)

        presenter.timetable
            .do(onNext: { print($0.entries) })
            .map { $0.entries }
            .bind(to: tableView.rx.items(cellIdentifier: "TimetableCell",
                                         cellType: TimetableCell.self)) { _, elem, cell in
                cell.model = elem
            }
            .disposed(by: bag)

        presenter.requestError
            .bind(to: rx.error())
            .disposed(by: bag)
    }
}
