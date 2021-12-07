//
//  TestViewController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 06/12/21.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    
    var name, email, password: String?
    var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard let name = name,
              let email = email,
              let password = password,
              let photo = photo
              else { return }
        userPhoto.image = photo
        nameLbl.text = name
        emailLbl.text = email
        passwordLbl.text = password
    }
}
