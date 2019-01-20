//
//  CollectionsListService.swift
//  Shopify-S19
//
//  Created by Neelaksh Bhatia on 2019-01-19.
//  Copyright © 2019 Neelaksh Bhatia. All rights reserved.
//

import Foundation
import Alamofire

class CollectionsListService {

    static func fetchCollectionList(completion: @escaping ([CollectionListItem])->()) -> Void {
        var result: [CollectionListItem] = []
        let url = ShopifyServiceURL.collection_list_url
        
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [Any]]
                guard let first = json??.first,
                    let values = first.value as? [[String:Any]] else {
                        return
                }
                for case let value in values {
                    let collection = try? CustomCollectionModel(json: value)
                    guard let title = collection?.title,
                        let body = collection?.body_html,
                        let image = collection?.image,
                        let lastUpdatedTime = collection?.updated_at,
                        let api_id = collection?.admin_graphql_api_id else {
                            continue
                    }
                    let listItem =
                        CollectionListItem(title: title,
                                           body: body,
                                           image: image,
                                           lastUpdatedTime: lastUpdatedTime,
                                           api_id: api_id)
                    result.append(listItem)
                }
            }
            completion(result)
        }
    }
}

struct CustomCollectionModel {
    var id: Int?
    var handle: String?
    var title: String?
    var updated_at: String?
    var body_html: String?
    var published_at: String?
    var sort_order: String?
    var template_suffix: String?
    var published_scope: String?
    var admin_graphql_api_id: String?
    var image: ShopifyImage?

    init(json: [String:Any]) throws {
        guard let id = json["id"] as? Int else {
            throw SerializationError.missing("id")
        }
        guard let title = json["title"] as? String else {
            throw SerializationError.missing("title")
        }
        guard let body = json["body_html"] as? String else {
            throw SerializationError.missing("body")
        }
        guard let updated_at = json["updated_at"] as? String else {
            throw SerializationError.missing("updated_at")
        }
        guard let admin_graphql_api_id = json["admin_graphql_api_id"] as? String else {
            throw SerializationError.missing("graphql_api_id")
        }
        guard let imageJSON = json["image"] as? [String: Any] else {
            throw SerializationError.missing("ShopifyImage")
        }

        self.id = id
        self.title = title
        self.body_html = body
        self.updated_at = updated_at
        self.admin_graphql_api_id = admin_graphql_api_id
        self.image = ShopifyImage(json: imageJSON)
    }
}

struct ShopifyImage {
    var created_at: String?
    var alt: String?
    var width: CGFloat?
    var height: CGFloat?
    var src: String?

    init?(json: [String:Any]) {
        created_at = json["created_at"] as? String
        alt = json["alt"] as? String
        width = json["width"] as? CGFloat
        height = json["height"] as? CGFloat
        src = json["src"] as? String
    }
}
