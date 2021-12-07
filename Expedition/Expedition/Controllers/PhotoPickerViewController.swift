//
//  PhotoPickerViewController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 06/12/21.
//

import UIKit

protocol PhotoPickerViewControllerDelegate: class {
    func photoPickerDidSelectImage(image: UIImage)
}

class PhotoPickerViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    //MARK: - Atributes
    
    let imagePicker = UIImagePickerController()
    weak var delegate: PhotoPickerViewControllerDelegate?
    
    //MARK: -Life cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - Helper Methods
    
    func setupViews() {
        imagePicker.delegate = self
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.backgroundColor = UIColor.lapisBlue
        photoImageView.clipsToBounds = true
    }
    
    func presentPhotoSourceAlert() {
        let alert = UIAlertController(title: "Add profile photo", message: "What would you like to do?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {[weak self] (_) in
            self?.imagePicker.dismiss(animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "Take a photo", style: .default) {[weak self] (_) in
            self?.openCamera()
        }
        let photoLibraryAlert = UIAlertAction(title: "Select photo from library", style: .default) {[weak self] (_) in
            self?.openPhotoLibrary()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAlert)
        
        present(alert, animated: true, completion: nil)
    }
    
    func presentCameraAccessErrorAlert() {
        let alert = UIAlertController(title: "Camara Access", message: "Please grant us permission to use your device's camera", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { (_) in
            guard let appSettingsURL = URL(string: UIApplication.openSettingsURLString) else {return}
            if UIApplication.shared.canOpenURL(appSettingsURL) {
                UIApplication.shared.open(appSettingsURL, completionHandler: nil)
            }
        }
        
        alert.addAction(okAction)
        alert.addAction(settingsAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func presentPhotoLibraryAccessErrorAlert() {
        let alert = UIAlertController(title: "Photo Library Access", message: "Please grant us permission to access your photo library to continue", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { (_) in
            guard let appSettingsURL = URL(string: UIApplication.openSettingsURLString) else {return}
            if UIApplication.shared.canOpenURL(appSettingsURL) {
                UIApplication.shared.open(appSettingsURL, completionHandler: nil)
            }
        }
        
        alert.addAction(okAction)
        alert.addAction(settingsAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - IBActions
    
    @IBAction func selectPhotoButtonTapped(_ sender: Any) {
        presentPhotoSourceAlert()
    }
}

//MARK: - Extensions

extension PhotoPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            presentCameraAccessErrorAlert()
        }
    }
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else {
            presentPhotoLibraryAccessErrorAlert()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            guard let delegate = delegate else { return }
            delegate.photoPickerDidSelectImage(image: pickedImage)
            selectPhotoButton.setBackgroundImage(nil, for: .normal)
            photoImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
