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
    
    func createUserWith(firstName: String, middleName: String, lastName: String, email: String, profilePhoto: UIImage?) {
        
        CloudKitManager.shared.fetchAppleUserReference { [weak self] (reference) in
            guard let reference = reference else { return }
            let newUser = User(firstName: firstName, middleName: middleName, lastName: lastName, email: email, profilePhoto: profilePhoto, appleUserReference: reference)
            let newUserRecord = CKRecord(user: newUser)
            CloudKitManager.shared.saveNewUser(userRecord: newUserRecord) { (userRecord, error) in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n\(error)")
                }
                
                guard let userRecord = userRecord,
                      let savedUser = User(ckRecord: userRecord)
                else { return }
                self?.currentUser = savedUser
            }
        }
        
        
    }
    
    func fetchUser(completion: @escaping (CKRecord?)->Void) {
        CloudKitManager.shared.fetchUser { (records, error) in
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
