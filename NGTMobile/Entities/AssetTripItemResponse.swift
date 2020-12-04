//
//  AssetTripItemResponse.swift
//  NGTMobile
//
//  Created by Water Flower on 11/30/20.
//

import Foundation
import ObjectMapper

class AssetTripItemResponse : Mappable
{
    var status: String?
    var message: String?
    var token: String?
    var trip_list: [AssetTripItem]?
    var position: [AssetRouteItem]?
       
    required init?(map:Map) {

    }

    func mapping(map: Map) {
        self.status <- map["status"]
        self.message <- map["message"]
        self.token <- map["token"]
        self.trip_list <- map["trip_list"]
        self.position <- map["position"]
    }

}
