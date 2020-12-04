//
//  AssetItem.swift
//  NGTMobile
//
//  Created by Water Flower on 11/20/20.
//

import Foundation
import ObjectMapper

class AssetItem : Mappable
{
    var a_id: String?
    var a_name: String?
    var a_timestamp: String?
    var a_type: String?
    var a_lat: String?
    var a_lon: String?
    var a_loc: String?
    var a_user: String?
    var a_sp: String?
    var a_dir: String?
    var a_odo: String?
    var a_fav: String?
    var a_mon: String?
    var a_stat: String? // 0: stopped, 1: moving, 2: idle
    var a_alarm: String?
    var a_last_ack_alrm_id: String?
    var mon_interval: String?
    var mon_start_timestamp: String?
    var mon_stop_timestamp: String?
    var asset_cards_value: [AssetCardValueItems]?
    var more_items: [AssetMoreItems]?
    var notification_count: Int?
    
    required init?(map:Map) {
        notification_count = 10
    }

    func mapping(map: Map) {
        self.a_id <- map["a_id"]
        self.a_name <- map["a_name"]
        self.a_timestamp <- map["a_timestamp"]
        self.a_type <- map["a_type"]
        self.a_lat <- map["a_lat"]
        self.a_lon <- map["a_lon"]
        self.a_loc <- map["a_loc"]
        self.a_user <- map["a_user"]
        self.a_sp <- map["a_sp"]
        self.a_dir <- map["a_dir"]
        self.a_odo <- map["a_odo"]
        self.a_fav <- map["a_fav"]
        self.a_mon <- map["a_mon"]
        self.a_stat <- map["a_stat"]
        self.a_alarm <- map["a_alarm"]
        self.a_last_ack_alrm_id <- map["a_last_ack_alrm_id"]
        self.mon_interval <- map["mon_interval"]
        self.mon_start_timestamp <- map["mon_start_timestamp"]
        self.mon_stop_timestamp <- map["mon_stop_timestamp"]
        self.more_items <- map["more_items"]
        self.asset_cards_value <- map["asset_cards_value"]
    }

}
