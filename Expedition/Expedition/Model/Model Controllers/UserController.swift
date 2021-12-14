//
//  UserController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 05/12/21.
//

import UIKit
import CloudKit

class UserController {
    static let shared = UserController()
    
    var currentUser: User?
    
    //MARK: - CRUD
    
    func createUserWith(firstName: String, middleName: String, lastName: String, email: String, password: String, profilePhoto: UIImage?, completion: @escaping (Bool) -> Void) {
        
        //TODO: - ENCRYPT PASSWORD
        
        CloudKitManager.shared.fetchAppleUserReference { (appleReference) in
            guard let appleReference = appleReference else {print("Error fetching the icloud refrence") ; return completion(false)}
            
            let newUser = User(firstName: firstName, middleName: middleName, lastName: lastName, email: email, password: password, profilePhoto: profilePhoto, appleUserReference: appleReference)
            
            let newUserRecord = CKRecord(user: newUser)
            
            CloudKitManager.shared.publicDB.save(newUserRecord) { (record, error) in
                if let error = error{
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n\(error)")
                    return completion(false)
                }
                
                guard let record = record,
                      let savedUser = User(ckRecord: record)
                      else { return completion(false) }
                
                UserDefaults.standard.setValue(savedUser.email, forKey: Strings.UDSavedUserEmailKey)
                self.currentUser = savedUser
                print("New user successfully created and saved to iCloud")
                completion(true)
            }
        }
        
    }
    
    func fetchUser(completion: @escaping (CKRecord?)->Void) {
        CloudKitManager.shared.fetchUserFromCloud { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n\(error)")
                return completion(nil)
            }
            guard let records = records,
                  let foundUserRecord = records.first
                  else { return completion(nil) }
            return completion(foundUserRecord)
        }
    }
    
}
