//
//  SignInResponse.swift
//  NGTMobile
//
//  Created by Water Flower on 11/30/20.
//

import Foundation
import ObjectMapper

class SignInResponse : Mappable
{
    var status: String?
    var message: String?
    var token: String?
    var update_int: String?
    var max_monperiod: String?
    var group_distance: String?
    var asset_card_type: [AssetCardTypeItem]?
       
    required init?(map:Map) {

    }

    func mapping(map: Map) {
        self.status <- map["status"]
        self.message <- map["message"]
        self.token <- map["token"]
        self.update_int <- map["update_int"]
        self.max_monperiod <- map["max_monperiod"]
        self.group_distance <- map["group_distance"]
        self.asset_card_type <- map["asset_cards"]
        
    }

}

