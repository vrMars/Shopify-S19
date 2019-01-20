//
//  ProductListItem.swift
//  Shopify-S19
//
//  Created by Neelaksh Bhatia on 2019-01-19.
//  Copyright © 2019 Neelaksh Bhatia. All rights reserved.
//

import UIKit

class ProductListItem: NSObject {
    var title: String
    var body: String
    var image: UIImage
    var inventory: Int?
    var collectionFlag: Bool

    init(title: String, body: String, image: ShopifyImage?, inventory: Int) {
        self.title = title
        self.body = body
        self.inventory = inventory
        self.collectionFlag = false

        guard let imageURL = image?.src else {
            guard let imageURL = image?.alt else {
                self.image = UIImage(named: "placeholder")!
                return
            }
            let url = URL(string: imageURL)
            let data = try? Data(contentsOf: url!)
            self.image = UIImage(data: data!) ?? UIImage(named: "placeholder")!
            return
        }
        let url = URL(string: imageURL)
        let data = try? Data(contentsOf: url!)
        self.image = UIImage(data: data!) ?? UIImage(named: "placeholder")!
    }

    // secondary init for collection card
    init(title: String, body: String, image: UIImage) {
        self.title = title
        self.body = body
        self.image = image
        self.collectionFlag = true
    }
}
