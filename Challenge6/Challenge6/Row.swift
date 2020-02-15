//
//  Row.swift
//  Challenge6
//
//  Created by Luis Eduardo Gonzalez on 2020-02-02.
//  Copyright © 2020 Luis Eduardo Gonzalez. All rights reserved.
//

import Foundation
import UIKit

enum Row: CaseIterable {
    case top
    case middle
    case bottom
}

extension Row {
    var zPosition: CGFloat {
        switch self {
        case .top:
            return 0
        case .middle:
            return 3
        case .bottom:
            return 5
        }
    }

    var yPosition: CGFloat {
        switch self {
        case .top:
            return 520
        case .middle:
            return 365
        case .bottom:
            return 210
        }
    }
}
