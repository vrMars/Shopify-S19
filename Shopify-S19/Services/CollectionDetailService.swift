//
//  CollectionDetailService.swift
//  Shopify-S19
//
//  Created by Neelaksh Bhatia on 2019-01-19.
//  Copyright © 2019 Neelaksh Bhatia. All rights reserved.
//

import UIKit
import Alamofire

class CollectionDetailService {
    
    static func fetchCollects(collection_id: Int, completion: @escaping ([ProductListItem])->()) -> Void {
        var product_ids: [String] = []
        let url = ShopifyServiceURL.get_collection_url(collection_id: collection_id)
        
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [Any]]
                guard let first = json??.first,
                    let values = first.value as? [[String: Any]] else {
                    return
                }
                for case let value in values {
                    let collect = try? Collect(json: value)
                    guard let product_id = collect?.product_id else {
                        continue
                    }
                    product_ids.append(String(product_id))
                }
                let productIdString = product_ids.joined(separator: ",")
                if !product_ids.isEmpty {
                    var productListItems: [ProductListItem] = []
                    let product_url = ShopifyServiceURL.get_product_url(product_id: productIdString)

                    Alamofire.request(product_url).responseJSON(completionHandler: { response in
                        if let data = response.data {
                            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [Any]]
                            guard let first = json??.first,
                                let products = first.value as? [[String: Any]] else {
                                    return
                            }
                            for case let product in products {
                                let prod = try? Product(json: product)
                                guard let title = prod?.title,
                                    let body = prod?.body,
                                    let inventory = prod?.inventory,
                                    let image = prod?.image else {
                                        continue
                                }
                                productListItems.append(ProductListItem(title: title, body: body, image: image, inventory: inventory))
                            }
                        }
                        completion(productListItems)
                    })
                }
            }
        }
    }
}

struct Collect {
    var id: Int?
    var collection_id: Int?
    var product_id: Int?
    var featured: Bool?
    var created_at: String?
    var updated_at: String?
    var position: Int?
    var sort_value: String?

    init(json: [String: Any]) throws {
        guard let product_id = json["product_id"] as? Int else {
            throw SerializationError.missing("product_id")
        }
        self.product_id = product_id
    }
}

struct Product {
    var id: Int?
    var title: String?
    var body: String?
    var product_type: String?
    var inventory: Int? = 0
    var image: ShopifyImage?

    init(json: [String: Any]) throws {
        guard let id = json["id"] as? Int else {
            throw SerializationError.missing("id")
        }
        guard let title = json["title"] as? String else {
            throw SerializationError.missing("title")
        }
        guard let body = json["body_html"] as? String else {
            throw SerializationError.missing("body")
        }
        guard let product_type = json["product_type"] as? String else {
            throw SerializationError.missing("product_type")
        }
        guard let variants = json["variants"] as? [Any] else {
            throw SerializationError.missing("variants")
        }
        guard let imageJSON = json["image"] as? [String: Any] else {
            throw SerializationError.missing("image")
        }
        self.id = id
        self.title = title
        self.body = body
        self.product_type = product_type
        var totalInventory = 0
        for item in variants {
            guard let item = item as? [String: Any] else { continue }
            let variant = try? ShopifyVariants(json: item)
            totalInventory += variant?.inventory_quantity ?? 0
        }
        self.inventory = totalInventory
        self.image = ShopifyImage(json: imageJSON)
    }
}

struct ShopifyVariants {
    var inventory_quantity: Int?

    init(json: [String: Any]) throws {
        guard let inventory_quantity = json["inventory_quantity"] as? Int else {
            throw SerializationError.missing("id")
        }
        self.inventory_quantity = inventory_quantity
    }
}
