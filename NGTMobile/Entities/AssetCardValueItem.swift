//
//  AssetCardValueItem.swift
//  NGTMobile
//
//  Created by Water Flower on 11/30/20.
//

import Foundation
import ObjectMapper

class AssetCardValueItems : Mappable
{
    var a_card_no: String?
    var a_card_note: String?
    var a_card_item1: String?
    var a_card_item1_color: String?
    var a_card_item2: String?
    var a_card_item2_color: String?
    var a_card_item3: String?
    var a_card_item4_color: String?
    
    required init?(map:Map) {

    }

    func mapping(map: Map) {
        self.a_card_no <- map["a_card_no"]
        self.a_card_note <- map["a_card_note"]
        self.a_card_item1 <- map["a_card_item1"]
        self.a_card_item1_color <- map["a_card_item1_color"]
        self.a_card_item2 <- map["a_card_item2"]
        self.a_card_item2_color <- map["a_card_item2_color"]
        self.a_card_item3 <- map["a_card_item4"]
        self.a_card_item4_color <- map["a_card_item4_color"]
    }

}
