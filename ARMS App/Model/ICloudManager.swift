//
//  ICloudManager.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/11/24.
//

import Foundation
import CloudKit
import UIKit

class ICloudManager {
    static func checkICloudStatus(completion: @escaping (Bool, String?) -> Void) {
        CKContainer.default().accountStatus { accountStatus, error in
            if accountStatus == .noAccount {
              completion(false, """
                         
                         Sign in to you ICloud account to store your data.


                         """)
        }
                
            switch accountStatus {
                case .available:
                    completion(true, nil)
                    //checkICloudKitPermission(completion: completion)
                case .restricted, .couldNotDetermine, .noAccount:
                    completion(false, "ICloud access is restricted or could not be determined")
                default:
                    completion(false, "Unknown error occured while trying to sign in to ICloud")
            }
    }
            
  }
    

    
}

