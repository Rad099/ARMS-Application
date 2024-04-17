//
//  ViewController.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 12/20/23.
//

import UIKit
import CoreBluetooth

class HomeViewController: UIViewController {
    

    
    var bleManager: BLEManager!
    
    var pageViewController: PageViewController!
    var highPollutant: Bool = false
    
   
    // initialize shared classes
    var user: User? {
            didSet {
                // Update the view with new user data
                updateUserInterface()
            }
        }

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var batteryLabel: UILabel!
    
    @IBOutlet weak var connectionLabal: UILabel!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var batteryProgress: UIProgressView!
    @IBOutlet weak var pageContainerView: UIView!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var topShadowView: UIView!
    
    
    @IBOutlet weak var statusCircle: UIView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        bleManager = BLEManager()
        batteryLabel.text = "---"
        connectionLabal.text = "Device Not Connected"
        batteryProgress.isHidden = true
        configureStatusIndicator(isConnected: false)
        batteryProgress.progressTintColor = UIColor.green
        updateUserInterface()
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleConnected(_:)), name: .bleManagerConnectionChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBattery(_:)), name: .bleManagerBatteryUpdate, object: nil)
       

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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Now that Auto Layout has likely finished laying out the views, configure the status indicator.
        configureStatusIndicator(isConnected: false)
    }
     */
    
        /**
 Function that toggles the connection status based on the information received in a notification.
 
 - Parameter notification: The notification containing information about the connection status.
 */
@objc func toggleConnected(_ notification: Notification) {
    if let isConnected = notification.userInfo?["isConnected"] as? Bool {
        connectionLabal.text = isConnected ? "Device Connected" : "Device Not Connected"
        isConnected ? configureStatusIndicator(isConnected: true) : configureStatusIndicator(isConnected: false)
    }
}
    
    


/**
 Function that updates the battery level based on the information received in a notification.
 
 - Parameter notification: The notification containing information about the battery level.
 */
@objc func updateBattery(_ notification: Notification) {
    if let battLevel = notification.userInfo?["batteryUpdate"] as? Int {
        batteryLabel.text = battLevel == -1 ? "---": "\(battLevel)%"
        batteryProgress.isHidden = battLevel == -1 ? true : false
        if (battLevel != -1) {
            batteryProgress.setProgress((Float(battLevel))/100, animated: true)
            if (battLevel > 50) {
                batteryProgress.progressTintColor = UIColor.green
            }
            else if (battLevel < 50 && battLevel > 20) {
                batteryProgress.progressTintColor = UIColor.yellow
            } else if (battLevel < 20) {
                batteryProgress.progressTintColor = UIColor.red
            }
        }
    }
}

    
    deinit {
            NotificationCenter.default.removeObserver(self)
        }
  
func updateUserInterface() {
    guard isViewLoaded, let user = user else { return }
    
    let cornerRadius: CGFloat = 20
    welcomeLabel.text = "Hi, \(user.name)!"
    
    [pageContainerView, topView].forEach { view in
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
    }
    
    let shadowProperties: (color: CGColor, offset: CGSize, opacity: Float, radius: CGFloat) = (UIColor.black.cgColor, CGSize(width: 0, height: 7), 0.7, 5)
    
    [shadowView, topShadowView].forEach { view in
        view.layer.shadowColor = shadowProperties.color
        view.layer.shadowOffset = shadowProperties.offset
        view.layer.shadowOpacity = shadowProperties.opacity
        view.layer.shadowRadius = shadowProperties.radius
        view.layer.masksToBounds = false
    }
}
    

func configureStatusIndicator(isConnected: Bool) {
    let size = min(statusCircle.bounds.width, statusCircle.bounds.height)
    statusCircle.layer.cornerRadius = size / 2
    statusCircle.clipsToBounds = true
    statusCircle.layer.borderWidth = 0.5
    statusCircle.layer.borderColor = UIColor.clear.cgColor
    
    if isConnected {
        statusCircle.backgroundColor = UIColor.green
        addPulsingEffect(to: statusCircle)
    } else {
        resetStatusIndicator()
    }
}

func resetStatusIndicator() {
    statusCircle.layer.removeAllAnimations()
    statusCircle.backgroundColor = UIColor.red
}
    
func addPulsingEffect(to view: UIView) {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1.0
        pulseAnimation.fromValue = 0.5
        pulseAnimation.toValue = 1.05
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.infinity
        view.layer.add(pulseAnimation, forKey: "pulse")
    }

    
        
}

     
     


