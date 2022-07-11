//
//  ViewController.swift
//  Project8
//
//  Created by Mehmet Subaşı on 8.07.2022.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer : UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    //MARK: Property observer
    //MARK: When score chages, it directly affect!!!
    var score = 0 {
        didSet { //willSet
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var correctAnswer = 0
    var level = 1
    
    
    //MARK: - Creating and adding view elements such as labels, buttons, views and arranging layout
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false  //Eğer Layout'u biz oluşturacaksak, bu değer false / kapalı olmalı. Aksi durumda XCode kendi Auroresize yapabilir ve bizim kodlarımız geçerli olmaz.
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0  //it sets how many lines the text can wrap over. '0' means that "as many lines as it takes"
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical) // MARK: Bir görünümün gerçek boyutundan daha büyük hale getirilmeye direndiği önceliği ayarlar. Ne kadar küçük olacağı önceliği değil, büyük olacağı önceliğidir.
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical) //Bir görünümün gerçek boyutundan daha büyük hale getirilmeye direndiği önceliği ayarlar.
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped(_:)), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped(_:)), for: UIControl.Event.touchUpInside)
        view.addSubview(clear)
        
        //MARK: View
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
   
        //MARK: - Autolayout
        
        //MARK: view.layoutMarginsGuide -> Safe Area (afeAreaLayoutGuide)
        //MARK: Option 2: layoutMarginsGuide and safeAreaLayoutGuide are NOT exacly the same thing. Not quite: layoutMarginsGuide is inside the safeAreaLayoutGuide, so it will be slightly smaller.
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            //        let constraintTrailing = containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0)
            //        constraintTrailing.priority = UILayoutPriority(rawValue: 750.0)
            //        constraintTrailing.isActive = true
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalTo: submit.heightAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
                                    ])
  
        //MARK: - Buttons
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.layer.borderColor = UIColor.systemGray.cgColor
                letterButton.layer.borderWidth = 1
                letterButton.addTarget(self, action: #selector(letterTapped(_:)), for: UIControl.Event.touchUpInside)
                
                let frame = CGRect(x: column * width,
                                   y: row * height,
                                   width: width,
                                   height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
//        cluesLabel.backgroundColor = .green
//        answerLabel.backgroundColor = .red
//        currentAnswer.backgroundColor = .black
//        buttonsView.backgroundColor = .green
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadLevel()
        
    }

    //MARK: - Tap the letter buttons
    //MARK: (_sender solves the whole problem.)
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else {return}
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle) // Add the string to end of the current one and return new one.
                                                                        //There is a difference with append(). Append add it directly and chage the main one. Appending() add it but doesn't change the main one, it returns new one.
        activatedButtons.append(sender)
        sender.isHidden = true
        
    }
    
    //MARK: - Tap the submit button
    //MARK: Controls the answer and accept. Also change the score.
    //MARK: Property observer is affected by score's changing.
    
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else{return}
        
        if let solutionPosition = solutions.firstIndex(of: answerText){
            activatedButtons.removeAll()
            correctAnswer += 1
            
            //MARK: answersLabel'daki text'i dizi olarak al, gerekli yeri değiştir ve tekrar string olarak label'a yazdır.
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            //scoreLabel.text = String("Score: \(score)")
            
            if correctAnswer % 7 == 0 {
                let alert = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Let's go!", style: UIAlertAction.Style.default, handler: levelUp))
                present(alert, animated: true)
            }
        }else{
            let alert = UIAlertController(title: "Nope!", message: "As you know... This is wrong.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            present(alert, animated: true)
            score -= 1
        }
        
    }
    
    //MARK: - Level Up
    
    //MARK: We can use methods for the handler of a UIAlertAction. As long as the method accepts a UIAlertAction and returns nothing, you can use it.
    func levelUp(_: UIAlertAction){ // MARK: It has to accept UIAlertAction
        level += 1
        
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        correctAnswer = 0
        
        for button in letterButtons {
            button.isHidden = false
        }
    }
    
    //MARK: - Clear Button Tapped
    
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        
        for button in activatedButtons {
            button.isHidden = false
        }
        
        activatedButtons.removeAll()
        
    }
    
    
    //MARK: - Load Level Function (Main function)
    //MARK: This read the .txt, splits them and places the things.
    
    func loadLevel(){
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt"){
            if let levelContents = try? String(contentsOf: levelFileURL){
                var lines = levelContents.components(separatedBy: "\n")  //Line Break
                lines.shuffle() //Shuffle the array
                
                for (index, line) in lines.enumerated(){    //Follow the indexes
                    let parts = line.components(separatedBy: ": ") // ": "'dan itibaren ayır ve parts değişkenine at. [String]
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        //MARK: UILabel'a string olarak yazdırabiliyoruz!!! "/n" ile satır atlıyoruz. UILabel.numberOfLines = 0 ile maks satır sayısını belirliyoruz. 0 demek otomatik demek.
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)    //Remove white spaces and lines easily
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        letterBits.shuffle()
        
        if letterButtons.count == letterBits.count {
            for i in 0..<letterButtons.count{
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
        
    }
    
}

