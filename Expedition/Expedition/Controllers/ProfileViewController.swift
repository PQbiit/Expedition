//
//  ProfileViewController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 13/12/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userProfileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileImageView.image = UserController.shared.currentUser?.profilePhoto
        
    }
    

    @IBAction func optionsButtonTapped(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: Strings.UDSavedUserEmailKey)
        UserDefaults.standard.synchronize()
        let authNavViewController = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(identifier: Strings.authNavigationController)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(authNavViewController)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
