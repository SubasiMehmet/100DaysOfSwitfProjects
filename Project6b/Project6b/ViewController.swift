//
//  ViewController.swift
//  Project6b
//
//  Created by Mehmet Subaşı on 30.06.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Screen Width: \(view.frame.width)")
        print("Safe Area Width: \(view.safeAreaLayoutGuide.layoutFrame.width)")
        
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = .red
        label1.text = "THESE"
        label1.textAlignment = .center
        label1.sizeToFit()
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = .cyan
        label2.text = "ARE"
        label2.textAlignment = .center
        label2.sizeToFit()
        
        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = .yellow
        label3.text = "SOME"
        label3.textAlignment = .center
        label3.sizeToFit()
        
        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = .green
        label4.text = "AWESOME"
        label4.textAlignment = .center
        label4.sizeToFit()
        
        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = .orange
        label5.text = "LABELS"
        label5.textAlignment = .center
        label5.sizeToFit()
        
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
        
//        let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
//
//
//        for label in viewsDictionary.keys {
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
//        }
//
//
//        let metrics = ["labelHeight": 88]
//
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))
//
        
        //MARK: - https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage.html#//apple_ref/doc/uid/TP40010853-CH27-SW1
        //MARK: - https://stackoverflow.com/questions/54047396/how-to-use-visual-format-language-to-set-constraints-in-swift
        
        // MARK: - Multiply view.widthAnchor with 0.2 and add (-10)
          label1.heightAnchor.constraint(greaterThanOrEqualTo: view.widthAnchor, multiplier: 0.2, constant: -10).isActive = true
        // This ruins the view.
        // MARK: - Moreover
        // view.frame.widt OR view.safeAreaLayoutGuide.layoutFrame.width give the width as constant Double.
        
        
        
        //MARK: Make all label's height same. We did not determine any specific height. (Greater then 30)
        for label in [label2, label3, label4, label5] {
            label.heightAnchor.constraint(equalTo: label1.heightAnchor).isActive = true
        }
        
        
        var previous : UILabel?

        for label in[label1, label2, label3, label4, label4, label5] {
            // MARK: Make all label's height equal to width of view.
            //label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            //OR
            
            // MARK: It is negative!!! Because (equalTo: "A" and constant "B"( always says that the distance start from "A" and go rightward by "B"
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = false  //This is intentionally False.
            
            // MARK: These's priorities are not 1000 because of safeArea constraint.
            let trailingConstraint = label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            trailingConstraint.priority = UILayoutPriority(999)
            trailingConstraint.isActive = true

            let leadingConstraint = label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
            leadingConstraint.priority = UILayoutPriority(999)
            leadingConstraint.isActive = true
            
            // MARK: To stay in safe area from right and left side.
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
            
         
            //MARK: After for loop, by assigning label to last one, it leaves space between each other.
            //MARK: But for the first one, there is no previous and it goes to "else".
            if let previous = previous {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 40).isActive = true
                
            }else{
                //MARK: To stay in safe area from top side.
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }
            
            previous = label
        }
        
        // MARK: To stay in safe area from bottom.
         label5.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
         label5.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = false //This is intentionally False.

     
        
        
        //MARK: -
//        Every UIView has a set of anchors that define its layouts rules. The most important ones are widthAnchor, heightAnchor, topAnchor, bottomAnchor, leftAnchor, rightAnchor, leadingAnchor, trailingAnchor, centerXAnchor, and centerYAnchor.
//
//        Most of those should be self-explanatory, but it’s worth clarifying the difference between leftAnchor, rightAnchor, leadingAnchor, and trailingAnchor.
//        For me, left and leading are the same, and right and trailing are the same too.
//        MARK: leftAnchor = leadingAnchor  &  rightAnchor = trailingAnchor
                           
        
        // MARK: -
//        let constraintTrailing = containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0)
//        constraintTrailing.priority = UILayoutPriority(rawValue: 750.0)
//        constraintTrailing.isActive = true
                           
    }


}

