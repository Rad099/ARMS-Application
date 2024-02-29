//
//  TabViewController.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/9/24.
//

import Foundation
import UIKit
import CloudKit

class TabViewController: UITabBarController {
    var bleManager: BLEManager!
    var cloudManager = ICloudManager()
    var pendingAlertMessage: String?
    var currentUser = User()


    

    func showAlert(message: String, shouldCloseApp: Bool = false) {
        DispatchQueue.main.async {
            print("Attempting to show alert: \(message)")
            guard self.isViewLoaded && self.view.window != nil else {
                self.pendingAlertMessage = message
                return
            }
        }

        let alert = UIAlertController(title: "ICloud Required", message: message, preferredStyle: .alert)
        
        if shouldCloseApp {
            alert.addAction(UIAlertAction(title: "Close App", style: .destructive, handler: { _ in
                // Here, you can guide the user to close the app. Do not exit the app programmatically.
                // For example, you can display a message or leave the app in a non-functional state.
            }))
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let message = pendingAlertMessage {
                    showAlert(message: message)
                    pendingAlertMessage = nil
        }
        
        /*
        cloudManager.checkICloudStatus { [weak self] isSignedIn, errorMessage in
            guard let self = self else { return }
            DispatchQueue.main.async { [self] in
                if isSignedIn {
                    // Handle signed-in status
                    print("signed in to cloud")
                    return
                } else if let message = errorMessage {
                    // Pass true to suggest closing the app
                    self.showAlert(message: message, shouldCloseApp: true)
                }
            }
        }
         
         */
        
        
    }
    

    private func presentNewUserViewController() {
    // Instantiate using storyboard if needed
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let onboardingVC = storyboard.instantiateViewController(withIdentifier: "welcome") as! NewUserViewController
        onboardingVC.modalPresentationStyle = .fullScreen
        onboardingVC.completionHandler = { [weak self] newUser in
            self?.currentUser = newUser
            self?.updateChildViewControllers()
            self?.dismiss(animated: true) }
        present(onboardingVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        cloudManager.fetchUserRecord { record, error in
            DispatchQueue.main.async {
                if let record = record, let user = User.fromCKRecord(record) {
                    // Record exists and User object is created
                    print("User fetched: \(user.name)")
                    self.currentUser = user
                } else {
                    // Either record is nil or there was an error fetching the record
                    if let error = error {
                        print("Error fetching record: \(error)")
                    } else {
                        print("No record found")
                    }
                    self.presentNewUserViewController()
                }
                self.updateChildViewControllers()
            }
        }

        bleManager = BLEManager()
        updateChildViewControllers()
    }
    
    func updateChildViewControllers() {
        if let viewControllers = self.viewControllers {
            for viewController in viewControllers {
                if let homeTab = viewController as? HomeViewController  {
                    homeTab.user = self.currentUser
                } else if let settingsTab = viewController as? SettingsViewController {
                    settingsTab.User = self.currentUser
                  
                } else if let exposureTab = viewController as? ExposureViewController {
                   // exposureTab.User = self.currentUser
                }
            }
        }
    }
}
