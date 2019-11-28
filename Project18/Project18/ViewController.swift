//
//  ViewController.swift
//  Project18
//
//  Created by Luis Eduardo Gonzalez on 2019-11-27.
//  Copyright © 2019 Luis Eduardo Gonzalez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("I'm inside the viewDidLoad() method!")
        print(1, 2, 3, 4, 5)
        print(1, 2, 3, 4, 5, separator: "-")
        print("Some message", terminator: "")
        assert(1 == 1, "Maths failure!")
        assert(1 == 2, "Maths failure!")
    }


}

