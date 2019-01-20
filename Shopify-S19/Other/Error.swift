//
//  Error.swift
//  Shopify-S19
//
//  Created by Neelaksh Bhatia on 2019-01-20.
//  Copyright © 2019 Neelaksh Bhatia. All rights reserved.
//

import Foundation

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}
