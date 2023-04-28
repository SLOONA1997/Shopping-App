//
//  ProductCollectionCell.swift
//  ShoppingApp
//
//  Created by apple on 28/04/23.
//

import UIKit

class ProductCollectionCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var primaryImgView: UIImageView!
    
    func configure(model: Product) {
        self.priceLbl.text = "$\(model.price ?? 0)"
        self.titleLbl.text = model.title
        self.primaryImgView.setImage(url: model.images?.first)
    }
}
