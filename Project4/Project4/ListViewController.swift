//
//  ListViewController.swift
//  Project4
//
//  Created by Luis Eduardo Gonzalez on 2019-03-24.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UITableViewController {
    var sites = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        if let path = Bundle.main.path(forResource: "sites", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: path)
                self.sites = contents.components(separatedBy: ", ")
            }
            catch {
                let ac = UIAlertController(title: "Error", message: "Couldn't load list of sites", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(ac, animated: true)
            }
        } else {
            let ac = UIAlertController(title: "Error", message: "File not found", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        }
        
        sites.sort()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Site", for: indexPath)
        cell.textLabel?.text = sites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Browser") as? ViewController {
            vc.selectedWebsite = sites[indexPath.row]
            vc.allowedWebsites = sites
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
