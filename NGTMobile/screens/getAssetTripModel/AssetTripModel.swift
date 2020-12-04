//
//  AssetTripModel.swift
//  NGTMobile
//
//  Created by Water Flower on 11/30/20.
//

import Foundation
import Alamofire
import ObjectMapper

class AssetTripModel: NSObject {
    
    var assetTripProtocol: AssetTripProtocol?
    
    public func assetTrips(selected_asset: AssetItem, ts_date: String) {
        
        let username = Utiles.getUsername()
        let token = Utiles.getToken()

        let param: Parameters = [
            "uid": username,
            "token": token,
            "a_id": selected_asset.a_id!,
            "ts_date": ts_date
        ]

        AF.request(Constant.BASE_URL + "/getTripSummary", method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON{ [self]
            response in
            print(response)
            switch response.result {
                case .success(let value):
                    let jsonResponse = value as! NSDictionary
                    let responseEntity = Mapper<AssetTripItemResponse>().map(JSONObject: jsonResponse)
                    let status = responseEntity?.status
                    if status == "1" {
                        let assetTrips = responseEntity?.trip_list
                        assetTripProtocol?.onAssetTripSuccess(trips: assetTrips ?? [])
                    } else {
                        assetTripProtocol?.onAssetTripError(message: "auth_error")
                    }
                case .failure(let error):
                    assetTripProtocol?.onAssetTripError(message: "network_error")
            }
        }
    }
    
}
