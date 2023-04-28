//
//  ImagePickerManager.swift
//  ShoppingApp
//
//  Created by apple on 26/04/23.
//

import UIKit

typealias ImagePickerManagerCompletion = (UIImage?)->Void

final class ImagePickerManager: NSObject {
    
    static let sharedInstance = {
        ImagePickerManager()
    }()
    
    private var completion: ImagePickerManagerCompletion?
    
    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        return imagePicker
    }
    
    func showImagePickerOptions (_ completion: @escaping ImagePickerManagerCompletion) {
        self.completion = completion
        let topVc = UIViewController.topMostController
        let alertVC = UIAlertController (title: "Pick a Photo", message: "Choose a picture from Library or camera", preferredStyle: .actionSheet)
        //Image picker for camera
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            let cameraImagePicker = self.imagePicker(sourceType: .camera)
            topVc?.present(cameraImagePicker, animated: true)
        }
        //Image Picker for Library
        let libraryAction = UIAlertAction(title: "Library", style: .default) { (action) in
            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
            topVc?.present (libraryImagePicker, animated: true)
        }
        let cancelAction = UIAlertAction (title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction (cameraAction)
        alertVC.addAction (libraryAction)
        alertVC.addAction (cancelAction)
        topVc?.present(alertVC, animated: true, completion: nil)
    }
    
}

extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        completion?(info[.originalImage] as? UIImage)
         UIViewController.topMostController?.presentedViewController?.dismiss(animated: true)
    }
    
}
