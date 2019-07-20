//
//  Person.swift
//  Project10
//
//  Created by Luis Eduardo Gonzalez on 2019-06-23.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }

    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }

    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
