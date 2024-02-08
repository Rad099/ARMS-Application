//
//  HomeSubviewController.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/23/24.
//

import UIKit
import SwiftUI


class AQISubviewController: UIHostingController<ContentView> {
    
      // var progressData = ProgressData()
       

        required init?(coder: NSCoder) {
            super.init(coder: coder, rootView: ContentView(progressData: progressData))
            self.view.backgroundColor = .clear
            self.view.isOpaque = false
        }


    
    //progressBarImageView.frame = CGRect(x: 0, y: 0, width: 200, height: 100) // Adjust frame as needed
   
    func updateProgress(to newValue: Float) {
            // Call this function to update the progress
            progressData.progressValue = newValue
    }
    


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //updateProgress(to: 40)
        //setPollutantData(to: [pm1?.concentration ?? 0, pm2_5?.concentration ?? 0, pm10?.concentration ?? 0, pm1., 150, 76])
        // Make sure statusBar is not nil by checking if it's loaded
          /* if statusBar != nil {
                    statusBar.setProgress(15, animated: true)
               } else {
                   print("statusBar is not connected in Interface Builder")
               }
       */ print("pm loaded")
    }
    
    
    
}
