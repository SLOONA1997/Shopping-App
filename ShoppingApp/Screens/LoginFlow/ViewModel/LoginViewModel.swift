//
//  LoginViewModel.swift
//  ShoppingApp
//
//  Created by apple on 25/04/23.
//

import Foundation

enum LoginVMEvent {
    case startLoading
    case stopLoading
    case loggedInSuccessfully
    case failed(String)
}

typealias LoginEventHandler = ((LoginVMEvent) -> Void)

class LoginViewModel {

    let eventHandler: LoginEventHandler
    
    var loginModel: LoginModel? {
        didSet {
            if let model = loginModel {
                loginUser(loginModel: model)
            }
        }
    }
    
    init(eventHandler: @escaping LoginEventHandler) {
        self.eventHandler = eventHandler
    }
    
    func loginUser(loginModel: LoginModel) {
        eventHandler(.startLoading)
        APIManager.serverRequest(modelType: [String: String].self,
                                 apiType: .login(loginModel: loginModel)) {[weak self] result in
            self?.eventHandler(.stopLoading)
            switch result {
            case .success(let responseJson):
                print("LOGGED IN=======>",responseJson)
                UserSession.shared.saveSession(json: responseJson)
                self?.eventHandler(.loggedInSuccessfully)
            case .failure(let error):
                self?.eventHandler(.failed(error.localizedDescription))
            }
        }
    }
}
