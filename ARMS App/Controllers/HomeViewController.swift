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
   
   
    // labels
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var uvLabel: UILabel!
    @IBOutlet weak var aqLabel: UILabel!
    @IBOutlet weak var modeSwitch: UISwitch!
    @IBOutlet weak var timeLabel: UILabel!
    
    
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
        updateMode()
        
        

    }
    
    func didUpdateValue(_ uvIndex: Float) {
        DispatchQueue.main.async { [weak self] in // Use a weak reference to self to avoid retain cycles
            guard let strongSelf = self else { return }
                strongSelf.UVProgressView.progressValue = CGFloat(uvIndex)
            }
    }
    
    @IBAction func updateAQIOnPressed(_ sender: UISwitch) {
        updateMode()
    }
    
    func updateMode() {
       if modeSwitch.isOn {
           
           typeLabel.text = "1-Hour AQI Index"
           aqLabel.text = "AQI"
           timeLabel.text = "New data in... 1 hour"
            // init progress view Max values
            UVProgressView.maxValue = 11
            PM1ProgressView.maxValue = 500
            PM2_5ProgressView.maxValue = 500
            PM10ProgressView.maxValue = 500
            VOCProgressView.maxValue = 500
            COProgressView.maxValue = 500
            
            // For testing: apply hard coded values
            UVProgressView.progressValue = 0
            PM1ProgressView.progressValue = CGFloat(pm1!.currentHourIndex)
            PM2_5ProgressView.progressValue = CGFloat(pm2_5!.currentHourIndex)
            PM10ProgressView.progressValue = CGFloat(pm10!.currentHourIndex)
            VOCProgressView.progressValue = CGFloat(0)
            COProgressView.progressValue = CGFloat(co!.currentHourIndex)
       } else {
           // init progress view Max values
           typeLabel.text = "Indoor AQI Index"
           aqLabel.text = "IAQI"
           timeLabel.text = "New data in... 3 minutes"
           UVProgressView.maxValue = 11
           PM1ProgressView.maxValue = 100
           PM2_5ProgressView.maxValue = 100
           PM10ProgressView.maxValue = 100
           VOCProgressView.maxValue = 100
           COProgressView.maxValue = 100
           
           // For testing: apply hard coded values
           UVProgressView.progressValue = 0
           PM1ProgressView.progressValue = CGFloat(pm1!.currentIndoorIndex)
           PM2_5ProgressView.progressValue = CGFloat(pm2_5!.currentIndoorIndex)
           PM10ProgressView.progressValue = CGFloat(pm10!.currentIndoorIndex)
           VOCProgressView.progressValue = CGFloat(50)
           COProgressView.progressValue = CGFloat(co!.currentIndoorIndex)
       }
    }
    
    

    
}


