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
    let pm1 = pollutant(name: "pm1")
    let pm2_5 = pollutant(name: "pm2.5")
    let pm10 = pollutant(name: "pm10")
    let voc = pollutant(name: "voc")
    let co = pollutant(name: "co")
    let uv = pollutant(name: "uv")

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
        
        cloudManager.checkICloudStatus { [weak self] isSignedIn, errorMessage in
            guard let self = self else { return }
            DispatchQueue.main.async { [self] in
                if isSignedIn {
                    // Handle signed-in status
                    return
                } else if let message = errorMessage {
                    // Pass true to suggest closing the app
                    self.showAlert(message: message, shouldCloseApp: true)
                }
            }
        }
        
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
        self.cloudManager.fetchCurrentUser { user, error in
            DispatchQueue.main.async {
                if let user = user {
                    // Use the User object here
                    self.currentUser = user
                    print("User fetched: \(user.name)")
                    self.updateChildViewControllers()
                } else if let error = error {
                    // Handle any errors here
                    print("Error fetching current user: \(error.localizedDescription)")
                    self.presentNewUserViewController()
                    
                }
            }
        }
            

        

        bleManager = BLEManager()
        bleManager.uv = uv
        bleManager.pm1 = pm1
        bleManager.pm2_5 = pm2_5
        bleManager.pm10 = pm10
        bleManager.voc = voc
        bleManager.co = co
        
        updateChildViewControllers()
    }
    
    func updateChildViewControllers() {
        if let viewControllers = self.viewControllers {
            for viewController in viewControllers {
                if let homeTab = viewController as? HomeViewController  {
                    homeTab.User = self.currentUser
                    homeTab.pm1 = self.pm1
                    homeTab.pm2_5 = self.pm2_5
                    homeTab.pm10 = self.pm10
                    homeTab.co = self.co
                    homeTab.uv = self.uv
                } else if let settingsTab = viewController as? SettingsViewController {
                    settingsTab.User = self.currentUser
                    settingsTab.pm1 = self.pm1
                    settingsTab.pm2_5 = self.pm2_5
                    settingsTab.pm10 = self.pm10
                    settingsTab.co = self.co
                } else if let exposureTab = viewController as? ExposureViewController {
                    exposureTab.User = self.currentUser
                    exposureTab.pm1 = self.pm1
                    exposureTab.pm2_5 = self.pm2_5
                    exposureTab.pm10 = self.pm10
                    exposureTab.co = self.co
                }
            }
        }
    }
}
