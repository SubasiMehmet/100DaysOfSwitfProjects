//
//  ViewController.swift
//  Project7
//
//  Created by Mehmet Subaşı on 4.07.2022.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var sparePetitionsArray = [Petition]()
    
    static var myIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credit", style: UIBarButtonItem.Style.done, target: self, action: #selector(showCredit))
     //   navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(filterAlert))
     //   navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
        
        let searchItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(filterAlert))
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshList))
        
        navigationItem.setLeftBarButtonItems([searchItem, refreshItem], animated: true)
        
    //MARK: - Creating json url
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else{
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url){
                parse(json: data)
                holdSpare()
                return
            }
        }
            showError()
            
        
    }
    
    
    
    func showError() {
        let alert = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; check your connection and try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(alert, animated: true)
    }
    
    
    
    
    //MARK: - Calling jason data
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    
    
    @objc func showCredit(){
        let alert = UIAlertController(title: "Credit", message: "https://api.whitehouse.gov/v1/petitions.json?limit=100", preferredStyle: UIAlertController.Style.alert)
        let alertButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default)
        alert.addAction(alertButton)
        present(alert, animated: true)
    }
    
    
    
    @objc func filterAlert(){
        let alert = UIAlertController(title: "Filter", message: "Enter a text that you are looking for...", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField()
        let button  = UIAlertAction(title: "Filter", style: UIAlertAction.Style.default) { [weak alert] _ in
            guard let filteredText = alert?.textFields?[0].text else { return }
            if filteredText != ""{
                self.filter(filteredText)
            }
        }
        
        alert.addAction(button)
        present(alert, animated: true)
    }
    
    
    
    func filter(_ filteredText: String){
        filteredPetitions.removeAll(keepingCapacity: false)
        filteredPetitions = petitions.clone()
        
      //  for (index, petition) in filteredPetitions.enumerated() {
        for petition in filteredPetitions{
            if petition.title.contains(filteredText) == false {
                print("index: \(ViewController.myIndex)")
                print("title: \(petition.title)")
                print("willRemove: \(filteredPetitions[ViewController.myIndex].title)")
                filteredPetitions.remove(at: ViewController.myIndex)
                ViewController.myIndex -= 1
            }
            ViewController.myIndex += 1
        }
        
        petitions.removeAll(keepingCapacity: false)
        petitions = filteredPetitions.clone()
        tableView.reloadData()
        ViewController.myIndex = 0
    }
    
    func holdSpare(){
        sparePetitionsArray = petitions.clone()
    }
    
    
    
    @objc func refreshList(){
        petitions.removeAll(keepingCapacity: false)
        petitions = sparePetitionsArray.clone()
        tableView.reloadData()
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.textLabel?.font = .systemFont(ofSize: 16)
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    


}


