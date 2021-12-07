//
//  CloudKitManager.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 05/12/21.
//

import CloudKit

class CloudKitManager {
    static let shared = CloudKitManager()
    
    let publicDB = CKContainer.default().publicCloudDatabase
    let privateDB = CKContainer.default().privateCloudDatabase
    
    
    
    //MARK: - User DB handlers
    
    func fetchAppleUserReference(completion: @escaping (CKRecord.Reference?) -> Void) {
        CKContainer.default().fetchUserRecordID { (userRecord, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n\(error)")
                completion(nil)
            }
            
            guard let userRecord = userRecord else { return completion(nil) }
            let reference = CKRecord.Reference(recordID: userRecord, action: .deleteSelf)
            return completion(reference)
        }
    }
    
    func saveNewUser(userRecord: CKRecord, completion: @escaping (CKRecord?, Error?) -> Void) {
        self.publicDB.save(userRecord, completionHandler: completion)
    }
    
    func fetchUserFromCloud(completion: @escaping (_ records: [CKRecord]?, _ error: Error?) -> Void) {
        fetchAppleUserReference { [weak self] (appleReference) in
            guard let appleReference = appleReference else {
                return completion(nil,nil)
            }
            let predicate = NSPredicate(format: "%K == %@", argumentArray: [Strings.appleUserReferenceKey, appleReference])
            let query = CKQuery(recordType: Strings.userRecordTypeKey, predicate: predicate)
            self?.publicDB.perform(query, inZoneWith: nil, completionHandler: completion)
        }
    }
    
}
