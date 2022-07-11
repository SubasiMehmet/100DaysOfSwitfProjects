//
//  ViewController.swift
//  Project2
//
//  Created by Mehmet Subaşı on 17.06.2022.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!

    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var numberOfQuestion = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: UIBarButtonItem.Style.done, target: self, action: #selector(showScore))
        
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1

        // MARK: borderColor desires CGColor. In here, UIColor is converted into cgColor by adding .cgColor
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        
    }

    
    func askQuestion(action: UIAlertAction! = nil){
        
        
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
        self.title = (self.title ?? "") + " (Score: \(score))"
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        }else{
            title = "Wrong"
            score -= 1
        }
        
        if title == "Wrong" {
            title = "“Wrong! That’s the flag of \(countries[sender.tag].capitalized)"
        }
       
        
        //MARK: - ALERT
        //MARK: Creating alert after an alert. It uses like nested alert. Other alert is added to first one's button's action.
        
        let alert = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: UIAlertController.Style.alert)
        let finalButton = UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: nil)
        let okButton = UIAlertAction(title: "Continue", style: UIAlertAction.Style.default) { UIAlertAction in
            self.numberOfQuestion += 1
            if self.numberOfQuestion == 10 {
                let finalAlert = UIAlertController(title: "You Answered 10 Question", message: "Your final score is \(self.score)", preferredStyle: UIAlertController.Style.alert)
                finalAlert.addAction(finalButton)
                self.present(finalAlert, animated: true)
            }
        }
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        self.askQuestion()
        
        //MARK: - Another way to add alert easily.
        /*
        let alert = UIAlertController(title: title, message: "Your score is \(score)" , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { handler in
            self.askQuestion()
        }))
        present(alert, animated: true)
        
        */
         
          
    }

    @objc func showScore(){
        let alert = UIAlertController(title: "Current Score", message: "\(self.score)", preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(button)
        present(alert, animated: true)
    }
    

    
}

