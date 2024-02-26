//
//  NewUserViewController.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/14/24.
//

import UIKit
import CloudKit
import UserNotifications

class NewUserViewController: UIViewController, UITextFieldDelegate {
    var tempUser = User()
    let cloudManager = ICloudManager()
  
    
    var completionHandler: ((User) -> Void)?
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    var currentQuestionIndex = 0
    let questions = ["Please enter your name", "How old are you?", "Do you any type of heart disease? Enter yes or no", "Do you have any type of lung disease? Enter yes or no", "Do you have asthma?", "Do you have any other respiratory diseases?", "enter email"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestNotificationPermission()
        
        
        answerField.delegate = self
        showQuestion()
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    func showQuestion() {
        guard currentQuestionIndex < questions.count else {
            finishQuestions()
            return
        }
        
        questionLabel.text = questions[currentQuestionIndex]
        answerField.text = ""
        
        submitButton.isHidden = currentQuestionIndex != questions.count - 1
        
    }
    
    func finishQuestions() {
        // Hide Next Button and Show Submit Button
        nextButton.isHidden = true
        submitButton.isHidden = false
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        
        switch currentQuestionIndex {
        case 0:
            tempUser.name = answerField.text ?? "No name"
        case 1:
            if let age = Int(answerField.text ?? "") {
                tempUser.age = age
            }
        case 2:
            tempUser.heartDisease = (answerField.text?.lowercased() == "yes")
        case 3:
            tempUser.lungDisease = (answerField.text?.lowercased() == "yes")
            
        case 4: 
            tempUser.asthma = (answerField.text?.lowercased() == "yes")
        case 5:
            tempUser.resporatoryDisease = (answerField.text?.lowercased() == "yes")
        case 6:
            tempUser.email = (answerField.text ?? "")
        default:
            break
        }
        currentQuestionIndex += 1
        showQuestion()
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        let newUser = User(name: tempUser.name, age: tempUser.age, heart: tempUser.heartDisease, asthma: tempUser.asthma, lung: tempUser.lungDisease, resp: tempUser.lungDisease, email: tempUser.email)
        
        
        
        saveUserToiCloud(user: newUser)
    
        if let handler = completionHandler {
            handler(newUser)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    private func saveUserToiCloud(user: User) {
        cloudManager.saveUser(user: user) { record, error in
            if let error = error {
                print("Error saving user to iCloud: \(error.localizedDescription)")
                return
            }
            if let record = record {
                print("User saved successfully with record ID: \(record.recordID)")
            }
        }
    }
}

