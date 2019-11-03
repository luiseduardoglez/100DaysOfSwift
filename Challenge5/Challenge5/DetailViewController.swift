//
//  DetailViewController.swift
//  Challenge5
//
//  Created by Luis Eduardo Gonzalez on 2019-11-02.
//  Copyright © 2019 Luis Eduardo Gonzalez. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UITableViewController {
    var country: Country?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = country?.name
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FactCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let country = country else {
            fatalError()
        }
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value2,
                        reuseIdentifier: "FactCell")
        if indexPath.row == 0 {
            cell.textLabel?.text = "Area"
            cell.detailTextLabel?.text = "\(country.area)"
        }
        if indexPath.row == 1 {
            cell.textLabel?.text = "Population"
            cell.detailTextLabel?.text = "\(country.population)"
        }
        if indexPath.row == 2 {
            cell.textLabel?.text = "Capital"
            cell.detailTextLabel?.text = "\(country.capitalCity)"
        }
        if indexPath.row == 3 {
            cell.textLabel?.text = "Currency"
            cell.detailTextLabel?.text = "\(country.currency)"
        }
        return cell
    }
}
