//
//  ViewController.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 12/20/23.
//

import UIKit
import CoreBluetooth

class HomeViewController: UIViewController, PollutantDelegate {
    
    //var PollutantManager: pollutant!
    
    var gradientView: GradientView!
    
    // initialize shared classes
    var user: User? {
            didSet {
                // Update the view with new user data
                updateUserInterface()
            }
        }
    var pm1: Pollutant?
    var pm2_5 : Pollutant?
    var pm10:Pollutant?
    var co: Pollutant?
    var uv: UV?
   
   
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
        setupInitialGradient()
        // Create the gradient view
        updateUserInterface()
    }
    
    func setupInitialGradient() {
           // Create an initial gradient view, for example with the first mode's colors
           let initialColors = [UIColor.red, UIColor.blue] // Change as per your first mode colors
           gradientView = GradientView(colors: initialColors, locations: [0.0, 0.4])
           gradientView?.frame = self.view.bounds
           if let gradient = gradientView {
               self.view.insertSubview(gradient, at: 0)
           }
       }
    
    
    func didUpdateUVIndoor(_ index: Double) {
        if !modeSwitch.isOn {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.UVProgressView.progressValue = CGFloat(index)
            }
        }
    }
    
    func didUpdateUVHour(_ index: Double) {
        if modeSwitch.isOn {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.UVProgressView.progressValue = CGFloat(index)
            }
        }
    }
    // update hour index only when the switch is on
    func didUpdateHourIndex(_ index: Int, _ name: String) {
        if modeSwitch.isOn {
            DispatchQueue.main.async { [weak self] in // Use a weak reference to self to avoid retain cycles
                guard let strongSelf = self else { return }
                    if name == "pm1" {
                        strongSelf.PM1ProgressView.progressValue = CGFloat(index)
                    } else if name == "pm2.5" {
                        strongSelf.PM2_5ProgressView.progressValue = CGFloat(index)
                    } else if name == "pm10" {
                        strongSelf.PM10ProgressView.progressValue = CGFloat(index)
                    } else if name == "voc" {
                        strongSelf.VOCProgressView.progressValue = CGFloat(index)
                    } else if name == "co" {
                        strongSelf.COProgressView.progressValue = CGFloat(index)
                    }
                
            }
        }
    }
    
    // update indoor index only wheh the switch is off
    func didUpdateIndoorIndex(_ index: Int, _ name: String) {
        if !modeSwitch.isOn {
            DispatchQueue.main.async { [weak self] in // Use a weak reference to self to avoid retain cycles
                guard let strongSelf = self else { return }
                    if name == "pm1" {
                        strongSelf.PM1ProgressView.progressValue = CGFloat(index)
                    } else if name == "pm2.5" {
                        strongSelf.PM2_5ProgressView.progressValue = CGFloat(index)
                    } else if name == "pm10" {
                        strongSelf.PM10ProgressView.progressValue = CGFloat(index)
                    } else if name == "voc" {
                        strongSelf.VOCProgressView.progressValue = CGFloat(index)
                    } else if name == "co" {
                        strongSelf.COProgressView.progressValue = CGFloat(index)
                    }
                    
                }
        }
    }

    
    
    
    @IBAction func updateAQIOnPressed(_ sender: UISwitch) {
        updateMode()
    }
    
    func updateUserInterface() {
        guard isViewLoaded, let user = user else { return }
        print("App started")
        //bleManager.delegate = self
        pm1?.delegate = self
        pm2_5?.delegate = self
        uv?.delegate = self
        pm10?.delegate = self
        co?.delegate = self
        updateMode()
    }
    
    
    func updateMode() {
       if modeSwitch.isOn {
           
           let AQIcolor = [UIColor.blue, UIColor.black]
           gradientView?.updateGradient(colors: AQIcolor)
           typeLabel.text = "Ambient AQI Index"
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
            UVProgressView.progressValue = CGFloat(uv!.currentHourIndex)
            PM1ProgressView.progressValue = CGFloat(pm1?.currentHourIndex ?? 20)
            PM2_5ProgressView.progressValue = CGFloat(pm2_5?.currentHourIndex ?? 0)
            PM10ProgressView.progressValue = CGFloat(pm10?.currentHourIndex ?? 300)
            VOCProgressView.progressValue = CGFloat(25)
            COProgressView.progressValue = CGFloat(co?.currentHourIndex ?? 450)
            
       } else {
           // init progress view Max values
           let IAQIcolor = [UIColor.orange, UIColor.black]
           gradientView?.updateGradient(colors: IAQIcolor)
           
        
           
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
           UVProgressView.progressValue = CGFloat(uv!.currentIndoorIndex)
           PM1ProgressView.progressValue = CGFloat(pm1!.currentIndoorIndex)
           PM2_5ProgressView.progressValue = CGFloat(pm2_5!.currentIndoorIndex)
           PM10ProgressView.progressValue = CGFloat(pm10!.currentIndoorIndex)
           VOCProgressView.progressValue = CGFloat(50)
           COProgressView.progressValue = CGFloat(co!.currentIndoorIndex)
       }
    }
    
    

    
}


