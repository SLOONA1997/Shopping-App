//
//  SignupViewModel.swift
//  ShoppingApp
//
//  Created by apple on 26/04/23.
//

import Foundation

enum SignupVMEvent {
    case startLoading
    case stopLoading
    case userSignedUpSuccessfully
    case failed(String)
}

typealias SignupEventHandler = ((SignupVMEvent) -> Void)

class SignupViewModel {
    
    let eventHandler: SignupEventHandler
    
    var signupModel: (SignupModel, UploadFileModel?)? {
        didSet {
            if let model = signupModel?.1 {
                uploadImage(model: model)
            } else {
                userSignup()
            }
        }
    }
    
    init(eventHandler: @escaping SignupEventHandler) {
        self.eventHandler = eventHandler
    }
    
    private func uploadImage(model: UploadFileModel) {
        eventHandler(.startLoading)
        APIManager.serverRequest(modelType: [String: String].self, apiType: .uploadFile(uploadFileModel: model)) {[weak self] result in
            self?.eventHandler(.stopLoading)
            switch result {
            case .success(let json):
                if let fileUrl = json["location"] {
                    self?.signupModel?.0.avatar = fileUrl
                }
                self?.userSignup()
            case .failure(let error):
                self?.eventHandler(.failed(error.localizedDescription))
            }
        }
    }
    
    private func userSignup() {
        guard let model = signupModel?.0 else {
            return
        }
        APIManager.serverRequest(modelType: User.self, apiType: .signup(signupModel: model)) {[weak self] result in
            switch result {
            case .success(let responseJson):
                print("SIGNED UP=======>",responseJson)
                self?.eventHandler(.userSignedUpSuccessfully)
            case .failure(let error):
                self?.eventHandler(.failed(error.localizedDescription))
            }
        }
    }
    
}
