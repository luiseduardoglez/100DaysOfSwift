//
//  Photo.swift
//  Challenge4
//
//  Created by Luis Eduardo Gonzalez on 2019-07-21.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import Foundation

class Photo: NSObject, Codable {
    var caption: String
    var image: String

    init(caption: String, image: String) {
        self.caption = caption
        self.image = image
    }
}
