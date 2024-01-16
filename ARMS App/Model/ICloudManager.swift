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
    let db = CKContainer(identifier: "iCloud.ARMS-App").privateCloudDatabase
    
    func saveUser(user: User, completion: @escaping (_ record: CKRecord?, _ error: Error?) -> Void) {
        let record = user.toCKRecord()
        db.save(record) { savedRecord, error in
            completion(savedRecord, error)
        }
    }
    
    func fetchUserRecord(completion: @escaping (CKRecord?, Error?) -> Void) {
        let predicate = NSPredicate(value: true) // Adjust the predicate as needed
        let query = CKQuery(recordType: "User", predicate: predicate)

        let queryOperation = CKQueryOperation(query: query)
        var fetchedRecord: CKRecord?

        queryOperation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                print("did we get a record?")
                fetchedRecord = record
            case .failure(let error):
                print("Error fetching record: \(error)")
            }
        }

        queryOperation.queryResultBlock = { result in
                switch result {
                case .success(_):
                    print("did this succeed?")
                    print("fetched: \(fetchedRecord)")
                    completion(fetchedRecord, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }

        self.db.add(queryOperation)
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
