//
//  ViewController.swift
//  Challenge
//
//  Created by Luis Eduardo Gonzalez on 2019-03-23.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var countries = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let fm = FileManager.default
        let path = Bundle.main.resourcePath!

        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items {
            if item.hasSuffix(".png") {
                countries.append(item)
            }
        }

        countries.sort()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.textLabel?.text = String(countries[indexPath.row].dropLast(4))
        cell.imageView?.image = UIImage(named: countries[indexPath.row])
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        cell.imageView?.layer.borderWidth = 0.5
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = countries[indexPath.row]
            vc.customTitle = String(countries[indexPath.row].dropLast(4))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

