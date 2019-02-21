//
//  ViewController.swift
//  TramTracker
//
//  Created by Vasyl Myronchuk on 06/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import RxSwift
import RxCocoa
import TTKit

class MonitoringViewController: UIViewController, RepositoryClient {

    private static let showTimetableSegue = "ShowTimetableSegue"

    static let coordFromatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 6
        formatter.minimumIntegerDigits = 1
        return formatter
    }()

    // MARK: - Ivars

    var lineNumber = 35 // Can be setup after controller creation in future

    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!

    @IBOutlet weak var enableLocationButton: UIButton!

    private var presenter: MonitoringPresenterProtocol = MonitoringPresenter()

    private let latitudeVariable = BehaviorSubject<CLLocationDegrees>(value: 0)
    private let longitudeVariable = BehaviorSubject<CLLocationDegrees>(value: 0)

    private let bag = DisposeBag()

    // MARK: - Overrides

    override func viewDidLoad() {
        setupUI()
        presenter.view = self
        bindPresenter()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == MonitoringViewController.showTimetableSegue {
            guard let navVC = segue.destination as? UINavigationController,
                let timetableVC = navVC.topViewController as? TimetableViewController,
                let annotation = mapView.selectedAnnotations.compactMap({ ($0 as? StopAnnotation) }).first else {
                fatalError("Unexpected UI structure change")
            }

            timetableVC.stop = annotation.stop
            timetableVC.lineNumber = lineNumber
        }
    }
}

// MARK: - MonitoringViewProtocol

extension MonitoringViewController: MonitoringViewProtocol {
    var longitude: Observable<CLLocationDegrees> {
        return longitudeVariable
    }

    var latitude: Observable<CLLocationDegrees> {
        return latitudeVariable
    }

    var enableLocation: Observable<Void> {
        return enableLocationButton.rx.tap.asObservable()
    }
}

// MARK: - MKMapViewDelegate

extension MonitoringViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        latitudeVariable.onNext(mapView.centerCoordinate.latitude)
        longitudeVariable.onNext(mapView.centerCoordinate.longitude)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? StopAnnotation else { return nil }

        let identifier = "StopAnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.pinTintColor = annotation.isActive ? UIColor.stopActive
                                                               : UIColor.stopRegular
            annotationView?.canShowCallout = true
            let infoButton = UIButton(type: .infoLight)
            annotationView?.rightCalloutAccessoryView = infoButton
            infoButton.rx.tap.asObservable()
                .subscribe(onNext: { [weak self] in
                    self?.performSegue(withIdentifier: MonitoringViewController.showTimetableSegue, sender: self)
                })
                .disposed(by: bag)
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            views.compactMap { $0.annotation as? StopAnnotation }
                .forEach { mapView.selectAnnotation($0, animated: true) }
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let areaOverlay = overlay as? StopOverlay else { return MKOverlayRenderer(overlay: overlay) }

        let circleRenderer = MKCircleRenderer(overlay: areaOverlay)
        circleRenderer.lineWidth = 1.0
        let color = areaOverlay.isActive ? UIColor.stopActive : UIColor.stopRegular
        circleRenderer.strokeColor = color
        circleRenderer.fillColor = color.withAlphaComponent(0.3)
        return circleRenderer
    }
}

// MARK: - Private

private extension MonitoringViewController {
    func setupUI() {
        mapView.delegate = self

        let tapRecognizer = UITapGestureRecognizer()
        mapView.addGestureRecognizer(tapRecognizer)
        tapRecognizer.rx.event.asObservable()
            .subscribe(onNext: { [weak self] tap in
                let location = tap.location(in: self?.mapView)
                self?.handleTap(at: location)
            })
            .disposed(by: bag)
    }

    func bindPresenter() {
        presenter.locationEnabled
            .subscribe(onNext: { [weak self] enabled in
                self?.placeholderView.isHidden = enabled
                self?.contentView.isHidden = !enabled
                self?.mapView.showsUserLocation = enabled
            })
            .disposed(by: bag)

        presenter.enableLocationTitle
            .bind(to: enableLocationButton.rx.title())
            .disposed(by: bag)

        presenter.stops
            .subscribe(onNext: { [weak self] stops in
                self?.updateAnnotationsAndOverlays(with: stops)
            })
            .disposed(by: bag)
    }

    // MARK: - Annotations and overlays

    func addViewportAnnotations(for stops: [Stop]) {
        for stop in stops {
            addAnnotation(for: stop)
        }
    }

    @discardableResult
    func addAnnotation(for stop: Stop) -> StopAnnotation {
        let annotation = StopAnnotation(stop: stop, isActive: false)
        mapView.addAnnotation(annotation)
        return annotation
    }

    func removeAnnotation(for stop: Stop) {
        for annotation in mapView.annotations.compactMap({ $0 as? StopAnnotation })
        where annotation.stop == stop {
            mapView.removeAnnotation(annotation)
            break
        }
    }

    func addOverlays(for stops: [Stop]) {
        for stop in stops {
            let overlay = StopOverlay(stop: stop, isActive: false)
            mapView.addOverlay(overlay)
        }
    }

    func removeOverlay(for stop: Stop) {
        for overlay in mapView.overlays.compactMap({ $0 as? StopOverlay }) {
            if let overlayStop = overlay.stop, overlayStop == stop {
                mapView.removeOverlay(overlay)
                break
            }
        }
    }

    func updateAnnotationsAndOverlays(with stops: [Stop]) {
        mapView.removeOverlays(mapView.overlays)
        addOverlays(for: stops)

        autoZoom(for: stops)
    }

    func autoZoom(for stops: [Stop]) {
        var zoomRect = MKMapRect.null
        for stop in stops {
            let coord = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
            let annotationPoint = MKMapPoint(coord)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
            if zoomRect.isNull {
                zoomRect = pointRect
            } else {
                zoomRect = zoomRect.union(pointRect)
            }
        }
        mapView.setVisibleMapRect(zoomRect, animated: true)
    }

    // MARK: - Taps

    func handleTap(at location: CGPoint) {
        let stopAnnotations = mapView.annotations.compactMap({ $0 as? StopAnnotation })
        mapView.removeAnnotations(stopAnnotations)

        let tapCoord = mapView.convert(location, toCoordinateFrom: mapView)
        let tapLocation = CLLocation(latitude: tapCoord.latitude, longitude: tapCoord.longitude)

        for overlay in mapView.overlays.compactMap({ $0 as? StopOverlay }) {
            let stopLocation = CLLocation(latitude: overlay.stop.latitude,
                                          longitude: overlay.stop.longitude)
            if tapLocation.distance(from: stopLocation) < StopOverlay.radiusThreshold {
                addAnnotation(for: overlay.stop)
            }
        }
    }
}
