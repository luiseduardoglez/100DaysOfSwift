//
//  ActionViewController.swift
//  Extension
//
//  Created by Luis Eduardo Gonzalez on 2020-02-15.
//  Copyright © 2020 Luis Eduardo Gonzalez. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    var pageTitle = ""
    var pageURL = ""
    @IBOutlet weak var script: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectScript))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self, action: #selector(done))
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        if let inputItems = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItems.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self](dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let jsValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    self?.pageTitle = jsValues["title"] as? String ?? ""
                    self?.pageURL = jsValues["URL"] as? String ?? ""

                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }

                    if let urlIsEmpty = self?.pageURL.isEmpty, !urlIsEmpty,
                        let url = self?.pageURL, let host = URL(string: url)?.host,
                        let savedScript = UserDefaults.standard.string(forKey: host) {
                        self?.script.text = savedScript
                    }
                }
            }
        }
    }

    fileprivate func loadScript(_ script: String) {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJs = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJs]
        extensionContext?.completeRequest(returningItems: [item])
        UserDefaults.standard.set(script, forKey: pageURL)
    }

    @IBAction func done() {
        loadScript(script.text)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0,
                                               bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        script.scrollIndicatorInsets = script.contentInset

        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

    @objc func selectScript() {
        let ac = UIAlertController(title: "Choose a script", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "alert(document.title);", style: .default, handler: { [weak self] action in
            guard let script = action.title else { return }
            self?.loadScript(script)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(ac, animated: true)
    }

}
