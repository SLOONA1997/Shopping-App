//
//  UIView+Extension.swift
//  ShoppingApp
//
//  Created by apple on 26/04/23.
//

import UIKit

extension UIView {
    @IBInspectable var corner: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.clipsToBounds = true
        }
    }
    
    func addAction(target: Any?, action: Selector?) {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        tapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGesture)
    }
}
