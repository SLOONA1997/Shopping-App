//
//  LoginViewController.swift
//  ShoppingApp
//
//  Created by apple on 25/04/23.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    private var viewModel: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVM()
    }
    
    func configureVM() {
        let eventHandler: LoginEventHandler = {[weak self] event in
            switch event {
            case .startLoading:
                LoaderClass.addLoader(self, "Loading...")
            case .stopLoading:
                LoaderClass.hideLoader(self)
            case .loggedInSuccessfully:
                self?.showAlert(message: "Logged In Successfully",handler: {[weak self] _ in
                    UserSession.shared.checkIfUserLoggedIn()
                })
            case .failed(let message):
                self?.showAlert(message: message)
            }

        }
        viewModel = LoginViewModel(eventHandler: eventHandler)
    }
    
    //MARK: - Actions
    
    @IBAction func signupTapped() {
        let navVC = self.navigationController
        self.navigationController?.popViewController(animated: false)
        navVC?.topViewController?.performSegue(withIdentifier: "OnboardingToSignup", sender: nil)
    }
    
    @IBAction func loginClicked() {
        guard let emailText = emailTF.text, !emailText.isEmpty else {
            showAlert(message: "Please enter your email address")
            return
        }
        guard let password = passwordTF.text, !password.isEmpty else {
            showAlert(message: "Please enter your password")
            return
        }
        viewModel?.loginModel = LoginModel(email: emailText, password: password)
    }
}
