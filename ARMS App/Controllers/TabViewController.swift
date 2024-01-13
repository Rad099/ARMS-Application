//
//  TabViewController.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/9/24.
//

import Foundation
import UIKit

class TabViewController: UITabBarController {
    var bleManager: BLEManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //if User == nil {
        let User = User(name: "New user", age: 34, heart: false, asthma: false, lung: false, resp: false)
           // userManager.saveUser(user: User!)
       // }
        
        let pm1 = pollutant(name: "pm1")
        let pm2_5 = pollutant(name: "pm2.5")
        let pm10 = pollutant(name: "pm10")
        let voc = pollutant(name: "voc")
        let co = pollutant(name: "co")
        let uv = pollutant(name: "uv")

        bleManager = BLEManager()
        bleManager.uv = uv
        bleManager.pm1 = pm1
        bleManager.pm2_5 = pm2_5
        bleManager.pm10 = pm10
        bleManager.voc = voc
        bleManager.co = co
       
        if let viewControllers = self.viewControllers {
            for viewController in viewControllers {
                if let homeTab = viewController as? HomeViewController  {
                    homeTab.User = User
                    homeTab.pm1 = pm1
                    homeTab.pm2_5 = pm2_5
                    homeTab.pm10 = pm10
                    homeTab.co = co
                    homeTab.uv = uv
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
