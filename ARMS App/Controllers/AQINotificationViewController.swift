//
//  AQINotificationView.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/21/24.
//

import Foundation
import UIKit

class AQINotificationViewController: UIViewController {
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            // Perform initial view setup
            setupViews()
        }

        private func setupViews() {
            // Configure your views and UI elements here
            // For example, setting up labels, buttons, etc.

            view.backgroundColor = .white // Example: setting the background color
            // Add more UI setup code as needed
        }

    func configure(with notification: UNNotification) {
            // Configure the view with notification data
    }
    
}
