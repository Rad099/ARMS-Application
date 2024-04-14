//
//  HomeSubviewController.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/23/24.
//

import UIKit
import SwiftUI


class AQISubviewController: UIHostingController<ContentView> {
    
    var progressData = ProgressData()
       

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: ContentView(progressData: progressData, paqr: paqr))
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
