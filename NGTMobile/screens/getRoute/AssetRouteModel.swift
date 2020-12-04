//
//  AssetRouteModel.swift
//  NGTMobile
//
//  Created by Water Flower on 12/1/20.
//

import Foundation
//
//  AssetTripModel.swift
//  NGTMobile
//
//  Created by Water Flower on 11/30/20.
//

import Foundation
import Alamofire
import ObjectMapper

class AssetRouteModel: NSObject {
    
    var assetRouteProtocol: AssetRouteProtocol?
    
    public func assetRoute(selected_asset: AssetItem, t_id: String) {
        
        let username = Utiles.getUsername()
        let token = Utiles.getToken()

        var param: Parameters = [
            "uid": username,
            "token": token,
            "a_id": selected_asset.a_id!,
            "route_type": "1"
        ]
        if t_id == "" {
            param["route_type"] = "1"
        } else {
            param["route_type"] = "2"
            param["t_id"] = t_id
        }
        print(param)
        AF.request(Constant.BASE_URL + "/getRoute", method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON{ [self]
            response in
            print(response)
            switch response.result {
                case .success(let value):
                    let jsonResponse = value as! NSDictionary
                    let responseEntity = Mapper<AssetTripItemResponse>().map(JSONObject: jsonResponse)
                    let status = responseEntity?.status
                    if status == "1" {
                        let assetRoute = responseEntity?.position
                        assetRouteProtocol?.onAssetRouteSuccess(routes: assetRoute ?? [])
                    } else {
                        assetRouteProtocol?.onAssetRouteError(message: "auth_error")
                    }
                case .failure(let error):
                    assetRouteProtocol?.onAssetRouteError(message: "network_error")
            }
        }
    }
    
}
