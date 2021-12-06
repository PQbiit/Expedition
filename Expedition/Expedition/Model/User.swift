//
//  User.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 05/12/21.
//

import CloudKit
import UIKit

class User {
    var firstName: String
    var middleName: String?
    var lastName: String
    var email: String
    
    var profilePhoto: UIImage? {
        get{
            guard let photoData = self.profilePhotoData else { return nil }
            return UIImage(data: photoData)
        }set {
            self.profilePhotoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var profilePhotoData: Data?
    var profilePhotoAsset: CKAsset? {
        get{
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try profilePhotoData?.write(to: fileURL)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n\(error)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    var recordID: CKRecord.ID
    var appleUserReference: CKRecord.Reference
    
    init(firstName: String, middleName: String? = "", lastName: String, email: String, profilePhoto: UIImage?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserReference: CKRecord.Reference) {
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.email = email
        self.recordID = recordID
        self.appleUserReference = appleUserReference
        self.profilePhoto = profilePhoto
    }
    
}

extension User {
    convenience init?(ckRecord: CKRecord) {
        guard let firstName = ckRecord[Strings.fNameKey] as? String,
              let middleName = ckRecord[Strings.mNameKey] as? String,
              let lastName = ckRecord[Strings.lNameKey] as? String,
              let email = ckRecord[Strings.emailKey] as? String,
              let appleUserReference = ckRecord[Strings.appleUserReferenceKey] as? CKRecord.Reference
              else { return nil }
        var foundProfilePhoto: UIImage?
        if let profilePhotoAsset = ckRecord[Strings.profilePhotoAssetKey] as? CKAsset {
            do {
                guard let photoURL = profilePhotoAsset.fileURL else { return nil }
                let photoData = try Data(contentsOf: photoURL)
                foundProfilePhoto = UIImage(data: photoData)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n\(error)")
            }
        }
        
        self.init(firstName: firstName, middleName: middleName, lastName: lastName, email: email, profilePhoto: foundProfilePhoto, recordID: ckRecord.recordID, appleUserReference: appleUserReference)
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}

extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: Strings.userRecordTypeKey, recordID: user.recordID)
        self.setValue(user.firstName, forKey: Strings.fNameKey)
        self.setValue(user.middleName, forKey: Strings.mNameKey)
        self.setValue(user.lastName, forKey: Strings.lNameKey)
        self.setValue(user.email, forKey: Strings.emailKey)
        self.setValue(user.profilePhotoAsset, forKey: Strings.profilePhotoAssetKey)
        self.setValue(user.appleUserReference, forKey: Strings.appleUserReferenceKey)
        
    }
}
