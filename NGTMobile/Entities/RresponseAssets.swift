//
//  RresponseAssets.swift
//  NGTMobile
//
//  Created by Water Flower on 11/20/20.
//

import Foundation
import ObjectMapper

class ResponseAssets : Mappable
{
    var status: String?
    var message: String?
    var token: String?
    var assets: [AssetItem]?
       
    required init?(map:Map) {

    }

    func mapping(map: Map) {
        self.status <- map["status"]
        self.message <- map["message"]
        self.token <- map["token"]
        self.assets <- map["assets"]
        
    }

}
