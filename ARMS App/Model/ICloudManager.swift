//
//  ICloudManager.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/11/24.
//

import Foundation
import CloudKit
import UIKit

class ICloudManager: ObservableObject {
    var db = CKContainer(identifier: "iCloud.ARMS-App").privateCloudDatabase
    
    func saveUser(user: User, completion: @escaping (_ record: CKRecord?, _ error: Error?) -> Void) {
        let record = user.toCKRecord()
        db.save(record) { savedRecord, error in
            completion(savedRecord, error)
        }
    }
    
    func fetchCurrentUser(completion: @escaping (User?, Error?) -> Void) {
        let userRecord = CKRecord(recordType: "User")
        userRecord["Email"] = "userEmail"

        let predicate = NSPredicate(format: "email == %@", userEmail)
        let query = CKQuery(recordType: "User", predicate: predicate)

        db.perform(query, inZoneWith: nil) { (records, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }

                guard let record = records?.first, let user = User.fromCKRecord(record) else {
                    completion(nil, NSError(domain: "Error converting CKRecord to User", code: 0, userInfo: nil))
                    return
                }

                completion(user, nil)
            }
        }
    }
     
    

    func checkICloudStatus(completion: @escaping (Bool, String?) -> Void) {
        CKContainer(identifier: "iCloud.ARMS-App").accountStatus { accountStatus, error in
            if accountStatus == .noAccount {
                completion(false, """
                         
                         You need Sign in to your ICloud account to store your data.
                         
                         You need iCloud to use this application
                         
                         
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
    
    //func checkForExistingUserData(completion: @escaping (Bool) -> Void) {
    
    //}
}
