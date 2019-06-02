//
//  Petition.swift
//  Project7
//
//  Created by Luis Eduardo Gonzalez on 2019-06-02.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
