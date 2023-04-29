//
//  SpinnerSectionController.swift
//  ShoppingApp
//
//  Created by apple on 29/04/23.
//

import IGListKit
import UIKit

func spinnerSectionController() -> ListSingleSectionController {
    let configureBlock: ListSingleSectionCellConfigureBlock = { (_: Any,cell : UICollectionViewCell) -> () in
        (cell as? SpinnerCell)?.activityIndicator.startAnimating()
    }

    let sizeBlock = { (_: Any, context: ListCollectionContext?) -> CGSize in
        guard let context = context else { return .zero }
        return CGSize(width: context.containerSize.width, height: 100)
    }

    return ListSingleSectionController.init(cellClass: SpinnerCell.self, configureBlock: configureBlock, sizeBlock: sizeBlock)
}

final class SpinnerCell: UICollectionViewCell {

    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .medium
        self.contentView.addSubview(view)
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        activityIndicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }

}
