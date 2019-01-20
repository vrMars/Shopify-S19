//
//  ShopifyStrings.swift
//  Shopify-S19
//
//  Created by Neelaksh Bhatia on 2019-01-17.
//  Copyright © 2019 Neelaksh Bhatia. All rights reserved.
//

import Foundation

struct ShopifyStrings {
    static let collections_list_title = "Collections"
    static let collection_details = "Collection Details"
    static let inventory_units = "units"
    static let last_updated = "Last updated:"
}

struct ShopifyServiceURL {
    static let collection_list_url = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"

    static func get_collection_url(collection_id: Int) -> String {
        return "https://shopicruit.myshopify.com/admin/collects.json?collection_id=\(collection_id)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    }

    static func get_product_url(product_id: String) -> String {
        return "https://shopicruit.myshopify.com/admin/products.json?ids=\(product_id)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    }
}
