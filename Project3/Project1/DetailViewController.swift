//
//  DetailViewController.swift
//  Project1
//
//  Created by Mehmet Subaşı on 15.06.2022.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedImageNumber = 0
    var totalNumberOfImages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //title = selectedImage
        // MARK: Challenge
        title = "Picture \(selectedImageNumber) of \(totalNumberOfImages)"
        navigationItem.largeTitleDisplayMode = .never
        //navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        // MARK: Xcode doesn't allow to use directly selectedImage variable, because it is a optional variable.
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
            imageView.contentMode = .scaleAspectFill
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped(){
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8), let imageName = selectedImage else {
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, imageName], applicationActivities: [])
        //MARK: This line is about iPads. Because UIActivityViewController need to be shown somewhere.
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
    }
    
}
