//
//  LoaderClass.swift
//  ShoppingApp
//
//  Created by apple on 25/04/23.
//

import UIKit
import MBProgressHUD

class LoaderClass: NSObject {
        
    static func addLoader(_ viewController: UIViewController? = nil, _ message: String) {
        
        LoaderClass.hideLoader(viewController)
        DispatchQueue.main.async {
            if let viewController = viewController {
                MBProgressHUD.hide(for: viewController.view, animated: true)
                let loader = MBProgressHUD.showAdded(to: viewController.view, animated: true)
                loader.detailsLabel.text = message
            }
        }
    }
    
    static func hideLoader(_ viewController: UIViewController? = nil) {
        DispatchQueue.main.async {
            if let viewController = viewController {
                MBProgressHUD.hide(for: viewController.view, animated: true)
            }
        }
    }
}
