//
//  ViewController.swift
//  Challenge2
//
//  Created by Luis Eduardo Gonzalez on 2019-06-01.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self

        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clear))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.leftBarButtonItems = [clearButton]
        navigationItem.rightBarButtonItems = [shareButton, addButton]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }

    @objc func clear() {
        shoppingList.removeAll()
        tableView.reloadData()
    }

    @objc func share() {
        let list = shoppingList.joined(separator: "\n")
        let controller = UIActivityViewController(activityItems: [list], applicationActivities: [])
        controller.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(controller, animated: true)
    }

    func insert(item: String) {
        shoppingList.insert(item, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    @objc func add() {
        let alertController = UIAlertController(title: "Add item", message: nil, preferredStyle: .alert)
        alertController.addTextField()

        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak alertController] action in
            guard let answer = alertController?.textFields?[0].text else { return }
            self?.insert(item: answer)
        }

        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

