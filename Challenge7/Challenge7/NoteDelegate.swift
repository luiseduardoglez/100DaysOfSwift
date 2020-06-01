//
//  NoteDelegate.swift
//  Challenge7
//
//  Created by Luis Eduardo Gonzalez on 2020-05-31.
//  Copyright © 2020 Luis Eduardo Gonzalez. All rights reserved.
//

import Foundation
import UIKit

protocol NoteDelegate: class {
    func saveNote(_ note: Note)
    func deleteNote(_ note: Note)
}
