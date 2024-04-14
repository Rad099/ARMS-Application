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
                fetchedRecord = record
            case .failure(let error):
                print("Error fetching record: \(error)")
            }
        }

        queryOperation.queryResultBlock = { result in
                switch result {
                case .success(_):
                    print("fetched: \(String(describing: fetchedRecord))")
                    completion(fetchedRecord, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }

        self.db.add(queryOperation)
    }
    
    func updateUserRecord(user: User, completion: @escaping (Bool, Error?) -> Void) {
            let predicate = NSPredicate(format: "Email == %@", user.email)
            let query = CKQuery(recordType: "User", predicate: predicate)
            let queryOperation = CKQueryOperation(query: query)

            queryOperation.recordMatchedBlock = { recordID, result in
                switch result {
                case .success(let record):
                    DispatchQueue.main.async {
                        // Proceed to update the fetched record with new information
                        self.update(record: record, with: user, completion: completion)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }

            queryOperation.queryResultBlock = { result in
                if case .failure(let error) = result {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }

            db.add(queryOperation)
        }

        private func update(record: CKRecord, with user: User, completion: @escaping (Bool, Error?) -> Void) {
            // Update the CKRecord with new information from the user
            record["Name"] = user.name
            record["Age"] = user.age
            record["HeartDisease"] = user.heartDisease
            record["Asthma"] = user.asthma
            record["LungDisease"] = user.lungDisease
            record["RespiratoryDisease"] = user.resporatoryDisease

            db.save(record) { _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(false, error)
                    } else {
                        completion(true, nil)
                    }
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
            } else if accountStatus == .available {
                NotificationCenter.default.post(name: NSNotification.Name("UserDidSignInToiCloud"), object: nil)
                
            } else {
                
                switch accountStatus {
                case .restricted, .couldNotDetermine, .noAccount:
                    completion(false, "ICloud access is restricted or could not be determined")
                default:
                    completion(false, "Unknown error occured while trying to sign in to ICloud")
                }
            }
        }
        
        
        
    }
}
