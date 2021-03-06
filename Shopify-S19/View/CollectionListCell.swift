//
//  CollectionListCell.swift
//  Shopify-S19
//
//  Created by Neelaksh Bhatia on 2019-01-17.
//  Copyright © 2019 Neelaksh Bhatia. All rights reserved.
//

import UIKit
import SnapKit

// ** TODO **
// Figure out how to display this
// with proper constraints layout

class CollectionListCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var lastUpdatedLabel: UILabel!
    
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
