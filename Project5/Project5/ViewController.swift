//
//  ViewController.swift
//  Project5
//
//  Created by Mehmet Subaşı on 26.06.2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
 
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(prompForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startAgain))
        
        
        // MARK: - Reading all start.txt file in Bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n") //Next line character
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        

        
        startGame()
    }
    
    //MARK: Choose a random element
    func startGame(){
        title = allWords.randomElement()    //random element from an array
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    // MARK: Table Features
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func prompForAnswer(){
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        // MARK: - Trailing Closure
        // It captured self and ac as weak parameter and they have to used as optional
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in       // after weakly capturing, in is necessary
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
    //MARK: Action of the submit button
    func submit(_ answer: String){
        let lowerAnswer = answer.lowercased()
        
        let errorTitle : String
        let errorMessage : String
        
        if isPossible(word: lowerAnswer){
            if isOriginal(word: lowerAnswer){
                if isShort(word: lowerAnswer) {
                    if isReal(word: lowerAnswer){
                        if isStarter(word: lowerAnswer){
                            usedWords.insert(answer, at: 0)
                            
                            // MARK: Insert Row to A Table
                            let indexPath = IndexPath(row: 0, section: 0)
                            tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                            return
                            
                            //MARK: return for break. Important here because if return doesn't exist, code will continue after if conditions and errorTitle & errorMessage is not initialized and it will still want to present alert. There are some more different solution, but it is ok.
                        }else{
                            errorTitle = "Word is a starter word"
                            errorMessage = "You can't use starter word"
                        }
                    }else{
                        errorTitle = "Word is not recognized"
                        errorMessage = "You can't just make them up, you know!"
                    }
                    
                }else{
                    errorTitle = "Word is too short"
                    errorMessage = "Make a real one!"
                }
                
            }else{
                errorTitle = "Word is already used"
                errorMessage = "Be more original"
            }
        }else{
            guard let title = title else{return}
            errorTitle = "Word is not possible"
            errorMessage = "You can't spell that word from \(title.lowercased())"
        }
        
        makeAlert(title: errorTitle, message: errorMessage)
       
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else {return false}
    
        //MARK: Check for whether the word contains all characters of the new word. Otherwise, return false.
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            }else {
                return false
            }
        }
        return true
    }
    
    //MARK: Whether the word is contained by usedWord Array
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isShort(word: String) -> Bool {
        if word.utf16.count < 3 {
            return false
        }
        return true
    }
    
    func isStarter(word: String) -> Bool{
        if let title = title?.lowercased() {
            if title.hasPrefix(word){
                return false
            }else {return true}
        }else{return false}
    }
    
    
    
    //MARK: - Because of some compatibility problem of Swift and Objective-C, .utf16.count is the best choise. But if we have a loop processing the characters one by one, .count will be better option. For example, "é" might be 2 character for .count but not for .utf16.count
    //MARK: misspelledRange.location says the where misspelling is started and NSNotFound shows if there is misspelling or not. If misspelling is not found, .location takes a special value as NSNotFound (Not basic Integer)
    //MARK: Thanks to UITextChecker, we can control that word is a real or not. Just like controlling misspelling but for different reason.
    //MARK: NSNotFound means that "There is No 'That'". It does not mean "It is not available."
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default))
        present(alert, animated: true)
    }
    
    
    @objc func startAgain(){
        startGame()
    }
    
    
}

