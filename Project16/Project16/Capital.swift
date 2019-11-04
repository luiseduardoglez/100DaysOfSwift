//
//  Capital.swift
//  Project16
//
//  Created by Luis Eduardo Gonzalez on 2019-11-03.
//  Copyright © 2019 Luis Eduardo Gonzalez. All rights reserved.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String

    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
