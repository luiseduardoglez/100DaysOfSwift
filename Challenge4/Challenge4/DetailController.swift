//
//  DetailController.swift
//  Challenge4
//
//  Created by Luis Eduardo Gonzalez on 2019-07-22.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var photo: Photo?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let photo = photo else { return }

        title = photo.caption
        let path = getDocumentsDirectory().appendingPathComponent(photo.image)
        imageView.image = UIImage(contentsOfFile: path.path)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
