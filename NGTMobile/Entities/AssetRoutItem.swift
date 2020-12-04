//
//  AssetRoutItem.swift
//  NGTMobile
//
//  Created by Water Flower on 12/1/20.
//

import Foundation
import ObjectMapper

class AssetRouteItem : Mappable
{
    var a_timestamp: String?
    var a_lat: String?
    var a_lon: String?
    var a_sp: String?
    var a_dir: String?
       
    required init?(map:Map) {

    }

    func mapping(map: Map) {
        self.a_timestamp <- map["a_timestamp"]
        self.a_lat <- map["a_lat"]
        self.a_lon <- map["a_lon"]
        self.a_sp <- map["a_sp"]
        self.a_dir <- map["a_dir"]
        
    }

}
