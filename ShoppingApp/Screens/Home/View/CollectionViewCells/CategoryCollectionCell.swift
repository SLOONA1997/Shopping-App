//
//  CategoryCollectionCell.swift
//  ShoppingApp
//
//  Created by apple on 28/04/23.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var overlayView: UIView!
    
    func configure(model: Category) {
        self.titleLbl.text = model.name
        self.overlayView.backgroundColor = AppUtility.getRandomColorForOverlay()
        imgView.setImage(url: model.image ?? "")
    }
}
