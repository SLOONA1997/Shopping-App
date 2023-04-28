//
//  UploadFileModel.swift
//  ShoppingApp
//
//  Created by apple on 26/04/23.
//

import UIKit

//Currently supports on image file

struct UploadFileModel: Encodable {
    let params: [String: String]?
    let media: Media
    init?(params: [String : String]? = nil, media: UIImage) {
        guard let media = Media.init(withImage: media, for: "file") else {
            return nil
        }
        self.params = params
        self.media = media
    }
}

struct Media: Encodable {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    init?(withImage image: UIImage, for key: String) {
        self.key = key
        self.filename = "imagefile.jpg"
        self.mimeType = "image/jpeg"
        guard let imageData = image.jpegData(compressionQuality: 0.6) else {
            return nil
        }
        self.data = imageData
    }

}


