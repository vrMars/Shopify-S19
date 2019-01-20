//
//  ProductListCell.swift
//  Shopify-S19
//
//  Created by Neelaksh Bhatia on 2019-01-19.
//  Copyright © 2019 Neelaksh Bhatia. All rights reserved.
//

import UIKit

class ProductListCell: UICollectionViewCell {
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var inventoryLabel: UILabel!

    var isHeightCalculated: Bool = false

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if !isHeightCalculated {
            setNeedsLayout()
            layoutIfNeeded()
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            var newFrame = layoutAttributes.frame
            newFrame.size.width = CGFloat(ceil(Float(size.width)))
            layoutAttributes.frame = newFrame
            isHeightCalculated = true
        }
        return layoutAttributes
    }
}
