//
//  DetailViewController.swift
//  Challenge7
//
//  Created by Luis Eduardo Gonzalez on 2020-05-31.
//  Copyright © 2020 Luis Eduardo Gonzalez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var noteTextView: UITextView!
    weak var delegate: NoteDelegate?
    var note: Note?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        loadNoteText()
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeNote))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
        navigationItem.rightBarButtonItems = [saveButton, deleteButton, shareButton]
    }

    func loadNoteText() {
        if let note = note {
            noteTextView.text = note.text
        }
    }

    @objc func saveNote() {
        if let note = note {
            var editedNote = note
            editedNote.text = noteTextView.text
            delegate?.saveNote(editedNote)
        } else {
            let newNote = Note(id: UUID().uuidString, text: noteTextView.text, date: Date())
            delegate?.saveNote(newNote)
        }

        navigationController?.popViewController(animated: true)
    }

    @objc func removeNote() {
        if let note = note {
            delegate?.deleteNote(note)
        }
        navigationController?.popViewController(animated: true)
    }

    @objc func shareNote() {
        let text = noteTextView.text
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
