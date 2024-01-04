//
//  ViewController.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 12/20/23.
//

import UIKit
import CoreBluetooth

class HomeViewController: UIViewController, BLEManagerDelegate {
    var bleManager: BLEManager!
    
    // initialize shared classes
    var User: user?
    var pm1: pollutant?
    var pm2_5 : pollutant?
    var pm10:pollutant?
    var co: pollutant?
   
   
    
    // outlets for progress bars
    @IBOutlet weak var UVProgressView: CircularProgressBar!
    @IBOutlet weak var PM1ProgressView: CircularProgressBar!
    @IBOutlet weak var PM2_5ProgressView: CircularProgressBar!
    @IBOutlet weak var PM10ProgressView: CircularProgressBar!
    @IBOutlet weak var VOCProgressView: CircularProgressBar!
    @IBOutlet weak var COProgressView: CircularProgressBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("App started")
        bleManager = BLEManager()
        bleManager.delegate = self
        
        
        // init progress view Max values
        UVProgressView.maxValue = 11
        PM1ProgressView.maxValue = 500
        PM2_5ProgressView.maxValue = 500
        PM10ProgressView.maxValue = 500
        VOCProgressView.maxValue = 500
        COProgressView.maxValue = 500
        
        // For testing: apply hard coded values
        UVProgressView.progressValue = 0
        PM1ProgressView.progressValue = CGFloat(50)
        PM2_5ProgressView.progressValue = CGFloat(200)
        PM10ProgressView.progressValue = CGFloat(400)
        VOCProgressView.progressValue = CGFloat(50)
        COProgressView.progressValue = CGFloat(100)

        
    }
    
    func didUpdateValue(_ uvIndex: Float) {
        DispatchQueue.main.async { [weak self] in // Use a weak reference to self to avoid retain cycles
            guard let strongSelf = self else { return }
                strongSelf.UVProgressView.progressValue = CGFloat(uvIndex)
            }
    }
    
    

    
}


