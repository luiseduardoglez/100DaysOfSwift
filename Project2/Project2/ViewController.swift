//
//  ViewController.swift
//  Project2
//
//  Created by Luis Eduardo Gonzalez on 2019-03-16.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var countries = [String]()
    var correctAnswer = 0
    var score = 0
    var questionsAsked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(scoreTapped))
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us", "cuba"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    @objc func scoreTapped() {
        let ac = UIAlertController(title: "Score", message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        correctAnswer = Int.random(in: 0...2)
        questionsAsked += 1
        title = "\(countries[correctAnswer].uppercased()). Score: \(score)"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String
        let defaults = UserDefaults.standard

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            sender.transform = .identity
        }, completion: nil)
        
        if questionsAsked <= 10 {
            
            if sender.tag == correctAnswer {
                title = "Correct"
                score += 1
                message = "Your score is \(score)"
            } else {
                title = "Wrong"
                score -= 1
                message = "That's the flag of \(countries[sender.tag].uppercased()).\nYour score is \(score)"
            }
            
            if questionsAsked == 10 {
                button1.isEnabled = false
                button2.isEnabled = false
                button3.isEnabled = false

                let highScore = defaults.integer(forKey: "highScore")
                message = "Your final score is \(score)."
                if score > highScore {
                    defaults.set(score, forKey: "highScore")
                    message = "Your final score is \(score). \nThat's a new high score!"
                }

                let ac = UIAlertController(title: "The End", message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: askQuestion))
                present(ac, animated: true)
            } else {
                let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
                present(ac, animated: true)
            }
        }
    }
}

