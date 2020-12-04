//
//  MonitorAssetModel.swift
//  NGTMobile
//
//  Created by Water Flower on 11/25/20.
//

import Foundation
import Alamofire
import ObjectMapper

class MonitorAssetModel: NSObject {
    
    var monitorAssetProtocol: MonitorAssetProtocol?
    
    public func toggleMonitorAsset(toggled_asset: AssetItem, mon_interval: Int, mon_starttime: String, mon_stoptime: String) {
        
        let username = Utiles.getUsername()
        let token = Utiles.getToken()

        var param: Parameters = [
            "uid": username,
            "token": token,
            "a_id": toggled_asset.a_id!,
            "a_fav": toggled_asset.a_fav == "1" ? "0" : "1",
            "a_mon": toggled_asset.a_mon == "1" ? "0" : "1"
        ]
        if toggled_asset.a_mon != "1" {
            param["mon_interval"] = mon_interval
            param["mon_start_timestamp"] = mon_starttime
            param["mon_stop_timestamp"] = mon_stoptime
        }
        print(param)
        AF.request(Constant.BASE_URL + "/updateAsset", method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON{ [self]
            response in
            print(response)
            
            switch response.result {
                case .success(let value):
                    let jsonResponse = value as! NSDictionary
                    if let responseStatus = jsonResponse["status"] as? String {
                        if responseStatus == "1" {
                            monitorAssetProtocol?.onMonitorAssetSuccess(message: "success")
                        } else {
                            monitorAssetProtocol?.onMonitorAssetError(message: "auth_error")
                        }
                    } else {
                        monitorAssetProtocol?.onMonitorAssetError(message: "auth_error")
                    }
                case .failure(let error):
                    monitorAssetProtocol?.onMonitorAssetError(message: "network_error")
            }
        }
    }
    
}
