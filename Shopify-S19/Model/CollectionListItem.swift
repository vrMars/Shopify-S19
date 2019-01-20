//
//  CollectionListItem.swift
//  Shopify-S19
//
//  Created by Neelaksh Bhatia on 2019-01-18.
//  Copyright © 2019 Neelaksh Bhatia. All rights reserved.
//

import UIKit

class CollectionListItem: NSObject {
    var title: String
    var body: String
    var image: UIImage
    var lastUpdatedTime: Date
    var api_id: Int

    init(title: String, body: String, image: ShopifyImage?, lastUpdatedTime: String, api_id: String) {
        self.title = title
        self.body = body

        if let number = Int(api_id.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
            self.api_id = number
        } else {
            self.api_id = -1
        }

        let dateFormatter = ISO8601DateFormatter()
        //according to date format your date string
        guard let date = dateFormatter.date(from: lastUpdatedTime) else {
            fatalError()
        }
        self.lastUpdatedTime = date //Convert String to Date

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

}
