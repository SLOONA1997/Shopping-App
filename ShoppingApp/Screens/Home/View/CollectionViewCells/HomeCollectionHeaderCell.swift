//
//  HomeCollectionHeaderCell.swift
//  ShoppingApp
//
//  Created by apple on 28/04/23.
//

import UIKit

class HomeCollectionHeaderCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel?

    var title: String {
        get {
            return titleLabel?.text ?? ""
        }
        set {
            self.titleLabel?.text = newValue
        }
    }
    //MARK: - Actions
    @IBAction func seeAllClicked() {
        
    }
}
