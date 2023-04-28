//
//  UIViewController+Extension.swift
//  ShoppingApp
//
//  Created by apple on 25/04/23.
//

import UIKit

extension UIViewController {
    
    static var topMostController: UIViewController? {
        let rootVc = UIApplication.shared.keyWindow?.rootViewController
        if let topNvc = rootVc as? UINavigationController {
            return topNvc.topViewController
        }
        return rootVc
    }
    
    func showAlert(title: String? = nil, message: String, handler: ((UIAlertAction)->Void)? = nil) {
        let alertController = UIAlertController.init(title: title,
                                                     message: message,
                                                     preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: handler))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
