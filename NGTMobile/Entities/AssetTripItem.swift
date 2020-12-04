//
//  AssetTripItem.swift
//  NGTMobile
//
//  Created by Water Flower on 11/30/20.
//

import Foundation
import ObjectMapper

class AssetTripItem : Mappable
{
    var t_id: String?
    var t_start_loc: String?
    var t_start_time: String?
    var t_stop_loc: String?
    var t_stop_time: String?
    var t_dist: String?
    var t_duration: String?
    var t_driver: String?
    var t_remark: String?
    
    required init?(map:Map) {

    }

    func mapping(map: Map) {
        self.t_id <- map["t_id"]
        self.t_start_loc <- map["t_start_loc"]
        self.t_start_time <- map["t_start_time"]
        self.t_stop_loc <- map["t_stop_loc"]
        self.t_stop_time <- map["t_stop_time"]
        self.t_dist <- map["t_dist"]
        self.t_duration <- map["t_duration"]
        self.t_driver <- map["t_driver"]
        self.t_remark <- map["t_remark"]
    }

}
