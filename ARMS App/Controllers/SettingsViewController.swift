//
//  SettingsViewController.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/4/24.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    var User: User!
    
    // initialize shared classes

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
        
        print("settings loaded")
        nameLabel.text = ("Name: \(User.name)")
        nameText.text = ("\(User.name)")
        ageText.text = ("\(User.age)")
        heartText.text = ("\(User.heartDisease)")
        lungText.text = ("\(User.lungDisease)")
        asthmaText.text = ("\(User.asthma)")
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateButton.setTitle("Update User", for: .normal)
    }
    
    @IBAction func confirmUpdateTapped(_ sender: UIButton) {
        if updateUser() == 1 {
            updateButton.setTitle("User Updated!", for: .normal)
        } else {
            updateButton.setTitle("Error Updating!", for: .normal)
        }

    }
    
    private func updateUser() -> Int {
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
        } else if (newHeartStatus != "true" || newHeartStatus != "false") {
            verfiy = 0
        } else if (newLungStatus != "true" || newLungStatus != "false") {
            verfiy = 0
        } else if (newAsthmaStatus != "true" || newAsthmaStatus != "false") {
            verfiy = 0
        }
        
        if (verfiy == 1) {
           // User.setUpdates(name: newName, age: Int(newAge)!, heart: Bool(newHeartStatus)!, lung: Bool(newLungStatus)!, asthma: Bool(newAsthmaStatus)!)
            return 0
        }
        
        return 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
}
