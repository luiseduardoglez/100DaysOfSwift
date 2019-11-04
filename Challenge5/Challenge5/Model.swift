//
//  Model.swift
//  Challenge5
//
//  Created by Luis Eduardo Gonzalez on 2019-11-02.
//  Copyright © 2019 Luis Eduardo Gonzalez. All rights reserved.
//

import Foundation

// MARK: - Countries
struct Countries: Codable {
    let countries: [Country]
}

// MARK: - Country
struct Country: Codable {
    let name, flag, capitalCity: String
    let area: Double
    let population: Int
    let currency: String
}
