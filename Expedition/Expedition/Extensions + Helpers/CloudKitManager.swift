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
    
    func validateUserCredentials(email: String, password: String, completion: @escaping (_ accountRecord: CKRecord?, _ error: Error?) -> Void) {
        
        let emailMatchPredicate = NSPredicate(format: "%K == %@", argumentArray: [Strings.emailKey, email])
        let passwordMarchPredicate = NSPredicate(format: "%K == %@", argumentArray: [Strings.passwordKey,password])
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [emailMatchPredicate,passwordMarchPredicate])
        
        let query = CKQuery(recordType: Strings.userRecordTypeKey, predicate: compoundPredicate)
        self.publicDB.perform(query, inZoneWith: nil) { [weak self] (userRecords, error) in
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n\(error)")
                return
            }
            
            guard let userRecords = userRecords,
                  let matchUserRecord = userRecords.first
                  else {return}
            self?.validateAccountOwnership(userRecord: matchUserRecord, completion: completion)
        }
    }
    
    func validateAccountOwnership(userRecord: CKRecord, completion: @escaping (_ accountRecord: CKRecord?, _ error: Error?) -> Void) {
        fetchAppleUserReference { (appleReference) in
            guard let appleReference = appleReference,
                  let recordAppleReference = userRecord[Strings.appleUserReferenceKey] as? CKRecord.Reference
                  else {return completion(nil,nil) }
            
            if recordAppleReference == appleReference {
                return completion(userRecord,nil)
            }else{
                print("You are not logged in to icloud from you phone!")
                return completion(nil,nil)
            }
        }
    }
    
}
