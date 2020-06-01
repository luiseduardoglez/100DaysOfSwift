//
//  ViewController.swift
//  Challenge7
//
//  Created by Luis Eduardo Gonzalez on 2020-05-03.
//  Copyright © 2020 Luis Eduardo Gonzalez. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        loadNotes()
        setupNavigationBar()
        setupTableView()
    }

    @objc func composeNote() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: Load Notes

    func saveNote() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: notes, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
        }
    }

    func loadNotes() {
        let defaults = UserDefaults.standard
        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            if let decodedNotes = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedNotes) as? [Note] {
                notes = decodedNotes
            }
        }
    }

    // MARK: UI
    func setupTableView() {
        tableView.tableFooterView = UIView()
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeNote))
        navigationItem.rightBarButtonItems = [composeButton]
    }

    // MARK: Table View
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: "NoteCell",
                                 for: indexPath) as? NoteCell else { fatalError() }
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.text
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.delegate = self
            vc.note = note
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: NoteDelegate {
    func saveNote(_ note: Note) {
        if let index = notes.lastIndex(where: { (item) -> Bool in
            item.id == note.id
        }) {
            notes[index] = note
        } else {
            notes.append(note)
        }
        tableView.reloadData()
    }

    func deleteNote(_ note: Note) {
        if let index = notes.lastIndex(where: { (item) -> Bool in
            item.id == note.id
        }) {
            notes.remove(at: index)
            tableView.reloadData()
        }
    }
}
