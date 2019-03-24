//
//  DetailViewController.swift
//  Challenge
//
//  Created by Luis Eduardo Gonzalez on 2019-03-23.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: String?
    var customTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView?.layer.borderColor = UIColor.lightGray.cgColor
        imageView?.layer.borderWidth = 0.5
        title = customTitle
        if let image = selectedImage {
            imageView.image = UIImage(named: image)
        }
    }
}
