//
//  LoginViewController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 06/12/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoContainerView: UIView!
    @IBOutlet weak var loginFormButton: UIButton!
    @IBOutlet weak var signUpFormButton: UIButton!
    @IBOutlet weak var fNameTextField: UITextField!
    @IBOutlet weak var mNameTextField: UITextField!
    @IBOutlet weak var lNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    
    //MARK: - Attributes
    var status = false
    var profilePhoto: UIImage?
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - Helper Methods
    
    func setupViews() {
        toggleToLogIn()
        photoContainerView.translatesAutoresizingMaskIntoConstraints = true
        photoContainerView.layer.cornerRadius = photoContainerView.frame.height / 2
        photoContainerView.layer.borderWidth = 5.0
        photoContainerView.layer.borderColor = UIColor.hunterGreen?.cgColor
        photoContainerView.clipsToBounds = true
    }
    
    func toggleToLogIn() {
        status = false
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.titleLabel.text = "Log in"
            self?.photoContainerView.isHidden = true
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
        status = true
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.titleLabel.text = "Sign up"
            self?.photoContainerView.isHidden = false
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
    
    func presentTestView() {
        DispatchQueue.main.async {
            let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "testViewController") as! TestViewController
            
            detailsVC.name = UserController.shared.currentUser?.firstName
            detailsVC.email = UserController.shared.currentUser?.email
            detailsVC.password = UserController.shared.currentUser?.password
            detailsVC.photo = UserController.shared.currentUser?.profilePhoto
            
            detailsVC.isModalInPresentation = true
            detailsVC.modalPresentationStyle = .formSheet
            
            self.present(detailsVC, animated: true, completion: nil)
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func loginFormButtonTapped(_ sender: Any) {
        toggleToLogIn()
    }
    
    @IBAction func signUpFormButton(_ sender: Any) {
        toggleToSignUp()
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        if status {
            //Register new user
            registerNewUser { [weak self] (success) in
                if success {
                    self?.presentTestView()
                }
            }
        }else{
            //Log in user
            loginUser { [weak self] (success) in
                if success{
                    self?.presentTestView()
                }
            }
        }
    }
    
    // MARK: - EMAIL: Log in/Register functions
    
    func registerNewUser(completion: @escaping (Bool) -> Void) {
        //Get user data form textfields and check its no empty
        guard let firstName = fNameTextField.text,
              let middleName = mNameTextField.text,
              let lastName = lNameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let passwordConfirmation = confirmPasswordTextField.text,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !passwordConfirmation.isEmpty
              else { return completion(false) }
        
        //Check that the password and passwordConfirmation values match
        guard password == passwordConfirmation else {
            //Present Password alert
            return completion(false)
        }
        
        //Check that the current logged user (current Apple ID) hasn't registered an account already
        UserController.shared.fetchUser { [weak self] (userRecord) in
            //No account with a reference to the current logged user's Apple ID was found
            if userRecord == nil {
                //Create a new user account
                UserController.shared.createUserWith(firstName: firstName, middleName: middleName, lastName: lastName, email: email, password: password, profilePhoto: self?.profilePhoto) { (success) in
                    if success {
                        return completion(true)
                    }
                }
            }else {
                //An account with a reference to the current logged user's Apple ID was found
                //PRESENT ALERT
                print("An account with this email already exist!")
                return completion(false)
            }
        }
        
    }
    
    func loginUser(completion: @escaping (Bool) -> Void) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else { return completion(false) }
        
        CloudKitManager.shared.validateUserCredentials(email: email, password: password) { (userRecord, error) in
            if let error = error {
                print("ERROR WHILE VALIDATING ACCOUNT DETAILS")
                print("Error in \(#function) : \(error.localizedDescription) \n---\n\(error)")
                return completion(false)
            }
            
            guard let userRecord = userRecord,
                  let currentUser = User(ckRecord: userRecord)
                  else {return completion(false)}
            
            UserController.shared.currentUser = currentUser
            return completion(true)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Strings.photoPickerVCSegueID {
            guard let destinationVC = segue.destination as? PhotoPickerViewController else { return }
            destinationVC.delegate = self
        }
    }

}

extension LoginViewController: PhotoPickerViewControllerDelegate {
    func photoPickerDidSelectImage(image: UIImage) {
        self.profilePhoto = image
    }
}
