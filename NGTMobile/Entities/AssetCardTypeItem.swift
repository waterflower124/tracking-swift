//
//  AssetCardTypeItem.swift
//  NGTMobile
//
//  Created by Water Flower on 11/30/20.
//

import Foundation
import ObjectMapper

class AssetCardTypeItem : Mappable, Codable
{
    var a_card_no: String?
    var a_card_type: String?
    var a_card_title: String?
    var a_card_item1_caption: String?
    var a_card_item2_caption: String?
    var a_card_item3_caption: String?
       
    required init?(map:Map) {

    }

    func mapping(map: Map) {
        self.a_card_no <- map["a_card_no"]
        self.a_card_type <- map["a_card_type"]
        self.a_card_title <- map["a_card_title"]
        self.a_card_item1_caption <- map["a_card_item1_caption"]
        self.a_card_item2_caption <- map["a_card_item2_caption"]
        self.a_card_item3_caption <- map["a_card_item3_caption"]
        
    }

}

