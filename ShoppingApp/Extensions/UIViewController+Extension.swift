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
    
    func showActionsheet(title:String,
                              message: String,
                              buttons:[String],
                              tapBlock: ((Int) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: buttons[0], style: .default , handler:{ (UIAlertAction)in
            if let block = tapBlock {
                block(0)
            }
        }))
        
        alert.addAction(UIAlertAction(title: buttons[1], style: .destructive , handler:{ (UIAlertAction)in
            if let block = tapBlock {
                block(1)
            }
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
