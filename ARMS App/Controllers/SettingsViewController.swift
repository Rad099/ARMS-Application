//
//  SettingsViewController.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/4/24.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    var User: user?
    
    // initialize shared classes
    var pm1: pollutant?
    var pm2_5 : pollutant?
    var pm10:pollutant?
    var co: pollutant?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var heartText: UITextField!
    @IBOutlet weak var lungText: UITextField!
    @IBOutlet weak var asthmaText: UITextField!
    
    @IBOutlet weak var updateButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameText.delegate = self
        ageText.delegate = self
        heartText.delegate = self
        lungText.delegate = self
        asthmaText.delegate = self
    
        nameLabel.text = ("Name: \(User!.name)")
        nameText.text = ("\(User!.name)")
        ageText.text = ("\(User!.age)")
        heartText.text = ("\(User!.heartDisease)")
        lungText.text = ("\(User!.lungDisease)")
        asthmaText.text = ("\(User!.asthma)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateButton.setTitle("Update User", for: .normal)
    }
    
    @IBAction func confirmUpdateTapped(_ sender: UIButton) {
        updateUser()
        userManager.saveUser(user: User!)
        updateButton.setTitle("User Updated!", for: .normal)
    }
    
    private func updateUser() {
        let newName = nameText.text ?? ""
        let newAge = ageText.text ?? ""
        let newHeartStatus = heartText.text ?? ""
        let newLungStatus = lungText.text ?? ""
        let newAsthmaStatus = asthmaText.text ?? ""
        var verfiy = 1
    
        
        if newName == "" {
           verfiy = 0
        } else if newAge == "" {
           verfiy = 0
        } else if (newHeartStatus == "True" || newHeartStatus == "False") {
            verfiy = 0
        } else if (newLungStatus == "True" || newLungStatus == "False") {
            verfiy = 0
        } else if (newAsthmaStatus == "True" || newAsthmaStatus == "False") {
          verfiy = 0
        }
        
        if (verfiy == 1) {
            User?.setUpdates(name: newName, age: Int(newAge)!, heart: Bool(newHeartStatus)!, lung: Bool(newLungStatus)!, asthma: Bool(newAsthmaStatus)!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
}
