//
//  ViewController.swift
//  Project16
//
//  Created by Luis Eduardo Gonzalez on 2019-11-03.
//  Copyright © 2019 Luis Eduardo Gonzalez. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.", wiki: "https://en.wikipedia.org/wiki/London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.", wiki: "https://en.wikipedia.org/wiki/Oslo")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.", wiki: "https://en.wikipedia.org/wiki/Paris")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", wiki: "https://en.wikipedia.org/wiki/Rome")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.", wiki: "https://en.wikipedia.org/wiki/Washington,_D.C.")

        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else {
            return nil
        }

        let identifier = "Capital"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = .orange

            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }

        let controller = DetailViewController()
        controller.url = capital.wiki
        present(controller, animated: true)
    }

    @IBAction func changeMapType(_ sender: Any) {
        let controller = UIAlertController(title: "Map Type", message: nil, preferredStyle: .actionSheet)
        let satelliteOption = UIAlertAction(title: "Satellite", style: .default) { [weak self](action) in
            self?.mapView.mapType = .satellite
        }
        let hybridOption = UIAlertAction(title: "Hybrid", style: .default) { [weak self](action) in
            self?.mapView.mapType = .hybrid
        }
        let standardOption = UIAlertAction(title: "Standard", style: .default) { [weak self](action) in
            self?.mapView.mapType = .standard
        }
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel)
        controller.addAction(satelliteOption)
        controller.addAction(hybridOption)
        controller.addAction(standardOption)
        controller.addAction(cancelOption)

        self.present(controller, animated: true, completion: nil)
    }
}

