//
//  ViewController.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 12/20/23.
//

import UIKit
import CoreBluetooth

class HomeViewController: UIViewController /*, PollutantDelegate */ {
    var pageViewController: PageViewController!
   
    // initialize shared classes
    var user: User? {
            didSet {
                // Update the view with new user data
                updateUserInterface()
            }
        }

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var pageContainerView: UIView!
    @IBOutlet weak var shadowView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserInterface()

        
        pageViewController = PageViewController()
        addChild(pageViewController)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageContainerView.addSubview(pageViewController.view)
        
        NSLayoutConstraint.activate([
                pageViewController.view.topAnchor.constraint(equalTo: pageContainerView.topAnchor, constant: 0.0),
                pageViewController.view.bottomAnchor.constraint(equalTo: pageContainerView.bottomAnchor, constant: 0.0),
                pageViewController.view.leadingAnchor.constraint(equalTo: pageContainerView.leadingAnchor, constant: 0.0),
                pageViewController.view.trailingAnchor.constraint(equalTo: pageContainerView.trailingAnchor, constant: 0.0),
            ])
        
        pageViewController.didMove(toParent: self)
    }
  
    
    
    func updateUserInterface() {
        guard isViewLoaded, let user = user else { return }
        print("App started")
        //bleManager.delegate = self
        welcomeLabel.text = "Hi, \(user.name)!"
        pageContainerView.layer.cornerRadius = 20
        pageContainerView.clipsToBounds = true
        topView.layer.cornerRadius = 40
        topView.clipsToBounds = true
        
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 7)
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowRadius = 5
        shadowView.layer.masksToBounds = false
        
    }
    
}
     
     


