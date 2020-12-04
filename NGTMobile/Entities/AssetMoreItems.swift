//
//  AssetMoreItems.swift
//  NGTMobile
//
//  Created by Water Flower on 11/20/20.
//

import Foundation
import ObjectMapper

class AssetMoreItems : Mappable
{
    var seq: String?
    var title: String?
    var info: String?
    var body: String?
    var url: String?
    var extbrowser: String?
    
    required init?(map:Map) {

    }

    func mapping(map: Map) {
        self.seq <- map["seq"]
        self.title <- map["title"]
        self.info <- map["info"]
        self.body <- map["body"]
        self.url <- map["url"]
        self.extbrowser <- map["extbrowser"]
    }

}
