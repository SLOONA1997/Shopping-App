//
//  UIImage+Extension.swift
//  ShoppingApp
//
//  Created by apple on 28/04/23.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(url:String?) {
        guard let _url = URL.init(string: url ?? "") else {
            return
        }
        let processor = DownsamplingImageProcessor(size: bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        kf.indicatorType = .activity
        kf.setImage(with: _url,placeholder: nil,options: [.processor(processor),.scaleFactor(UIScreen.main.scale),.transition(.fade(1)),.cacheOriginalImage])
    }
}
