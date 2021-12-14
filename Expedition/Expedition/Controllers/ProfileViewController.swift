//
//  ProfileViewController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 13/12/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var savedActivitiesCountLbl: UILabel!
    @IBOutlet weak var favoriteCitiesCountLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        guard let user = UserController.shared.currentUser else { return }
        userProfileImageView.image = user.profilePhoto
        userNameLbl.text = "\(user.firstName) \(user.middleName ?? "") \(user.lastName)"
        favoriteCitiesCountLbl.text = "99"
        savedActivitiesCountLbl.text = "99"
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
