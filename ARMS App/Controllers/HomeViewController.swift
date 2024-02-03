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
   

    
    
    
    //var PollutantManager: pollutant!
    
    //ar gradientView: GradientView!
    
    // initialize shared classes
    var user: User? {
            didSet {
                // Update the view with new user data
                updateUserInterface()
            }
        }
    var pm1: Pollutant?
    var pm2_5 : Pollutant?
    var pm10:Pollutant?
    var co: Pollutant?
    var uv: UV?
   
   
    // labels
    //@IBOutlet weak var pageContainerView: UIView!
    //@IBOutlet weak var shadowView: UIView!
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
    
   /*
   
    
    
    func didUpdateUVIndoor(_ index: Double) {
        if !modeSwitch.isOn {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.UVProgressView.progressValue = CGFloat(index)
            }
        }
    }
    
    func didUpdateUVHour(_ index: Double) {
        if modeSwitch.isOn {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.UVProgressView.progressValue = CGFloat(index)
            }
        }
    }
    // update hour index only when the switch is on
    func didUpdateHourIndex(_ index: Int, _ name: String) {
        if modeSwitch.isOn {
            DispatchQueue.main.async { [weak self] in // Use a weak reference to self to avoid retain cycles
                guard let strongSelf = self else { return }
                    if name == "pm1" {
                        strongSelf.PM1ProgressView.progressValue = CGFloat(index)
                    } else if name == "pm2.5" {
                        strongSelf.PM2_5ProgressView.progressValue = CGFloat(index)
                    } else if name == "pm10" {
                        strongSelf.PM10ProgressView.progressValue = CGFloat(index)
                    } else if name == "voc" {
                        strongSelf.VOCProgressView.progressValue = CGFloat(index)
                    } else if name == "co" {
                        strongSelf.COProgressView.progressValue = CGFloat(index)
                    }
                
            }
        }
    }
    
    // update indoor index only wheh the switch is off
    func didUpdateIndoorIndex(_ index: Int, _ name: String) {
        if !modeSwitch.isOn {
            DispatchQueue.main.async { [weak self] in // Use a weak reference to self to avoid retain cycles
                guard let strongSelf = self else { return }
                    if name == "pm1" {
                        strongSelf.PM1ProgressView.progressValue = CGFloat(index)
                    } else if name == "pm2.5" {
                        strongSelf.PM2_5ProgressView.progressValue = CGFloat(index)
                    } else if name == "pm10" {
                        strongSelf.PM10ProgressView.progressValue = CGFloat(index)
                    } else if name == "voc" {
                        strongSelf.VOCProgressView.progressValue = CGFloat(index)
                    } else if name == "co" {
                        strongSelf.COProgressView.progressValue = CGFloat(index)
                    }
                    
            }
        }
    }

    
    
    
    @IBAction func updateAQIOnPressed(_ sender: UISwitch) {
        
    }
    */
    
    
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
     
     


