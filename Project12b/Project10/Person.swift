//
//  Person.swift
//  Project10
//
//  Created by Luis Eduardo Gonzalez on 2019-06-23.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
