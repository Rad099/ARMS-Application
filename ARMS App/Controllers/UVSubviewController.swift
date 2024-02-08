//
//  VOCSubviewController.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/27/24.
//

import UIKit
import SwiftUI

class UVSubviewController: UIHostingController<UVContentView> {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: UVContentView())
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
    

    }
    
    
    
}

