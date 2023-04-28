//
//  SignUpViewController.swift
//  ShoppingApp
//
//  Created by apple on 26/04/23.
//

import UIKit

class SignupViewController: UIViewController {
//MARK: - Outlets
    @IBOutlet weak var profileImgVw: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var viewModel: SignupViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureListners()
    }
    
    func configureListners() {
        let eventHandler: SignupEventHandler = {[weak self] event in
            switch event {
            case .startLoading:
                LoaderClass.addLoader(self, "Loading...")
            case .stopLoading:
                LoaderClass.hideLoader(self)
            case .userSignedUpSuccessfully:
                self?.showAlert(message: "Signed Up Successfully",handler: {[weak self] _ in
                    self?.loginTapped()
                })
            case .failed(let message):
                self?.showAlert(message: message)
            }

        }
        viewModel = SignupViewModel(eventHandler: eventHandler)
        profileImgVw.addAction(target: self, action: #selector(pickImage))
    }
    
    @objc func pickImage() {
        ImagePickerManager.sharedInstance.showImagePickerOptions { selectedImage in
            DispatchQueue.main.async {
                if let selectedImage {
                    self.profileImgVw.image = selectedImage
                    self.profileImgVw.contentMode = .scaleAspectFill
                    self.profileImgVw.layer.cornerRadius = self.profileImgVw.bounds.self.width / 2
                    self.profileImgVw.tag = 1
                }
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction func loginTapped() {
        let navVC = self.navigationController
        self.navigationController?.popViewController(animated: false)
        navVC?.topViewController?.performSegue(withIdentifier: "OnboardingToLogin", sender: nil)
    }
    
    @IBAction func signupClicked() {
        guard let name = nameTF.text, !name.isEmpty else {
            showAlert(message: "Please enter your name")
            return
        }
        guard let email = emailTF.text, !email.isEmpty else {
            showAlert(message: "Please enter your email address")
            return
        }
        guard let password = passwordTF.text, !password.isEmpty else {
            showAlert(message: "Please enter the password you want to use")
            return
        }
        let signUpModel = SignupModel.init(email: email, password: password, name: name)
        let imageUploadModel: UploadFileModel?
        if let selectedImg = profileImgVw.image, profileImgVw.tag == 1 {
            imageUploadModel = UploadFileModel.init(media: selectedImg)
        } else {
            imageUploadModel = nil
        }
        viewModel?.signupModel = (signUpModel, imageUploadModel)
    }
}
