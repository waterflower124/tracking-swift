//
//  ListAssetItem.swift
//  NGTMobile
//
//  Created by Water Flower on 11/24/20.
//

import Foundation
import ObjectMapper

class ListAssetItem {
    var a_status: String?
    var assetItems: [AssetItem]?
    
    init(a_status: String, assetItems: [AssetItem]) {
        self.a_status = a_status
        self.assetItems = assetItems
    }
}
