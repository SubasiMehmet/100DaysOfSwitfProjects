//
//  ViewController.swift
//  Milestone_2_P4-6
//
//  Created by Mehmet Subaşı on 3.07.2022.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingListArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        navigationController?.hidesBarsOnSwipe = true
        navigationController?.hidesBottomBarWhenPushed = true
        //navigationController?.hidesBarsOnTap = true
        
       
        
        configureNavigationBar(titleColor: .systemPurple, backgoundColor: .white, tintColor: .systemYellow, title: "My Shopping List", preferredLargeTitle: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareList))
        
    }
    

    
    // MARK: -
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItem", for: indexPath)
        cell.textLabel?.text = shoppingListArray[indexPath.row]
        return cell
        

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingListArray.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingListArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            tableView.reloadData()
        }
    }
    
    // MARK: -
    
    
    @objc func addItem(){
        
        let alert = UIAlertController(title: "Add Item", message: "You can whatever you want", preferredStyle: UIAlertController.Style.alert)

        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cancelButton)
        alert.addTextField()
        let addButton = UIAlertAction(title: "Add", style: .default) { [weak self, weak alert] _ in
            guard let newItem = alert?.textFields?[0].text else{return}
            //self?.shoppingListArray.removeAll(keepingCapacity: true) We don't use it because we don't need to remove all items in the list.
            //self?.shoppingListArray.insert(newItem, at: 0)
            self?.shoppingListArray.append(newItem)
            self!.tableView.reloadData()
        }
        alert.addAction(addButton)
        present(alert, animated: true)
        
    }
    
    @objc func shareList(){
        let list = shoppingListArray.joined(separator: "\n")
        
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(vc, animated: true)
    }

}

extension UITableViewController {
func configureNavigationBar(titleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
   
    if #available(iOS 15.0, *) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor]
        navBarAppearance.titleTextAttributes = [.foregroundColor: titleColor]
        navBarAppearance.backgroundColor = backgoundColor

        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = tintColor
        navigationItem.title = title

    } else {
        // Fallback on earlier versions
        navigationController?.navigationBar.barTintColor = backgoundColor
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = title
    }
}}


