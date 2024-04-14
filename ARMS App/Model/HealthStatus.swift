//
//  HealthStatus.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 3/27/24.
//

import Foundation


// struct for putting strings with health type
enum HealthStatus: String, CaseIterable {
    case heartDisease = "Heart-sensitive"
    case asthma = "Asthma-sensitive"
    case lungDisease = "Lung-sensitive"
    case respDisease = "Respiratory-sensitive"
    
}

