//
//  Colors.swift
//  Project20
//
//  Created by Luis Eduardo Gonzalez on 2020-02-17.
//  Copyright © 2020 Luis Eduardo Gonzalez. All rights reserved.
//

import SpriteKit

enum Colors: CaseIterable {
    case cyan
    case green
    case red
}

extension Colors {
    var uiColor: UIColor {
        switch self {
        case .cyan:
            return .cyan
        case .green:
            return .green
        case .red:
            return .red
        }
    }
}
