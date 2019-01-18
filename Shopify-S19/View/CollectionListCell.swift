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
    var title: UILabel

    override init(frame: CGRect) {
        title = UILabel(frame: .zero)
        super.init(frame: frame)
        title.text = ""
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
//        title.snp.makeConstraints { make in
//            make.left.top.equalToSuperview().offset(10)
//            make.right.bottom.equalToSuperview().offset(-10)
//        }
    }


}
