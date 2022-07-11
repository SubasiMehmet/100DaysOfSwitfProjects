//
//  ViewController.swift
//  Project1
//
//  Created by Mehmet Subaşı on 14.06.2022.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Strom Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
       
        
        
        // MARK: - Important for NavigationBar Settings
        // MARK: Specially the line about scrollEdgeAppearance
        // MARK: In this case, these setting are set from Storyboard
        /*
        if #available(iOS 15, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
               // appearance.backgroundColor = .systemGray
                navigationController?.navigationBar.standardAppearance = appearance;
                navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
            }
        */
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl"){
                pictures.append(item)
            }
            // MARK: Sort the array - CH
            pictures.sort()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        //MARK: Change the font of the textLabel - CH
       // cell.textLabel?.font = .systemFont(ofSize: 20)
        return cell
    }
    
    
    // MARK: Directly use selectedImage from vc.
    // MARK: Type casting is necessary by using instantiateViewController because Xcode creates any ViewController with that identifier.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedImageNumber = indexPath.row + 1
            vc.totalNumberOfImages = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}

