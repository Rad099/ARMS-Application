//
//  ExposureViewController.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/4/24.
//
import UIKit
import SwiftUI

class ExposureViewController: UIHostingController<ExposureView> {
    
    required init?(coder: NSCoder) {
        let context = PersistenceController.shared.container.viewContext
        let rootView = ExposureView(managedObjectContext: context)
        
        super.init(coder: coder, rootView: rootView)
        
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
