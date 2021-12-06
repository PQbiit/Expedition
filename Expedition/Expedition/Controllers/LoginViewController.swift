//
//  LoginViewController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 06/12/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var loginFormButton: UIButton!
    @IBOutlet weak var signUpFormButton: UIButton!
    @IBOutlet weak var fNameTextField: UITextField!
    @IBOutlet weak var mNameTextField: UITextField!
    @IBOutlet weak var lNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - Helper Methods
    
    func setupViews() {
        toggleToLogIn()
    }
    
    func toggleToLogIn() {
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.loginFormButton.tintColor = UIColor.lapisBlue
            self?.loginFormButton.alpha = 1.0
            self?.signUpFormButton.tintColor = UIColor.textColor
            self?.signUpFormButton.alpha = 0.3
            self?.fNameTextField.isHidden = true
            self?.mNameTextField.isHidden = true
            self?.lNameTextField.isHidden = true
            self?.confirmPasswordTextField.isHidden = true
            self?.actionButton.setTitle("Log in", for: .normal)
        })
    }
    
    func toggleToSignUp() {
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.loginFormButton.tintColor = UIColor.textColor
            self?.loginFormButton.alpha = 0.3
            self?.signUpFormButton.tintColor = UIColor.lapisBlue
            self?.signUpFormButton.alpha = 1.0
            self?.fNameTextField.isHidden = false
            self?.mNameTextField.isHidden = false
            self?.lNameTextField.isHidden = false
            self?.confirmPasswordTextField.isHidden = false
            self?.actionButton.setTitle("Sign up", for: .normal)
        })
    }
    
    //MARK: - IBActions
    
    @IBAction func loginFormButtonTapped(_ sender: Any) {
        toggleToLogIn()
    }
    
    @IBAction func signUpFormButton(_ sender: Any) {
        toggleToSignUp()
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
