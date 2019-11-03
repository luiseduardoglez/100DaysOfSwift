//
//  ViewController.swift
//  Challenge5
//
//  Created by Luis Eduardo Gonzalez on 2019-10-22.
//  Copyright © 2019 Luis Eduardo Gonzalez. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [Country]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let items = try decoder.decode(Countries.self, from: data)
                countries = items.countries
              } catch {
                   // handle error
              }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath) as? CountryCell else {
            fatalError()
        }
        let country = countries[indexPath.row]
        cell.flagView.image = UIImage(named: country.flag)
        cell.name.text = country.name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countries[indexPath.row]
        let controller = DetailViewController()
        controller.country = country
        navigationController?.pushViewController(controller, animated: true)
    }
}

