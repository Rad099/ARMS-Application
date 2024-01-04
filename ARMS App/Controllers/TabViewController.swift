//
//  TabViewController.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/9/24.
//

import Foundation
import UIKit

class TabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var User = userManager.loadUser()
        if User == nil {
            User = user(name: "New user", age: 0, heart: false, asthma: false, lung: false)
            userManager.saveUser(user: User!)
        }
        
        let pm1 = pollutant(name: "pm1")
        let pm2_5 = pollutant(name: "pm2.5")
        let pm10 = pollutant(name: "pm10")
        let co = pollutant(name: "CO")
        
        if let viewControllers = self.viewControllers {
            for viewController in viewControllers {
                if let homeTab = viewController as? HomeViewController  {
                    homeTab.User = User
                    homeTab.pm1 = pm1
                    homeTab.pm2_5 = pm2_5
                    homeTab.pm10 = pm10
                    homeTab.co = co
                } else if let settingsTab = viewController as? SettingsViewController {
                    settingsTab.User = User
                    settingsTab.pm1 = pm1
                    settingsTab.pm2_5 = pm2_5
                    settingsTab.pm10 = pm10
                    settingsTab.co = co
                } else if let exposureTab = viewController as? ExposureViewController {
                    exposureTab.User = User
                    exposureTab.pm1 = pm1
                    exposureTab.pm2_5 = pm2_5
                    exposureTab.pm10 = pm10
                    exposureTab.co = co
                }
            }
        }
    }
}
