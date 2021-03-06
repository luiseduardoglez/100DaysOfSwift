//
//  DetailViewController.swift
//  Project1
//
//  Created by Luis Eduardo Gonzalez on 2019-03-14.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var customTitle: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(selectedImage != nil, "Image must has value")
        
        title = customTitle
        navigationItem.largeTitleDisplayMode = .never

        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
