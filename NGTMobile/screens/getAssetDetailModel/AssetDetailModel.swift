//
//  AssetDetailModel.swift
//  NGTMobile
//
//  Created by Water Flower on 11/29/20.
//

import Foundation
import Alamofire
import ObjectMapper

class AssetDetailModel: NSObject {
    
    var assetDetailProtocol: AssetDetailProtocol?
    
    public func assetDetail(selected_asset: AssetItem) {
        
        let username = Utiles.getUsername()
        let token = Utiles.getToken()

        let param: Parameters = [
            "uid": username,
            "token": token,
            "a_id": selected_asset.a_id!
        ]
        
        
        AF.request(Constant.BASE_URL + "/getAsset", method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON{ [self]
            response in
//            print(response)
            
            switch response.result {
                case .success(let value):
                    let jsonResponse = value as! NSDictionary
                    let responseEntity = Mapper<ResponseAssets>().map(JSONObject: jsonResponse)
                    let status = responseEntity?.status
                    if status == "1" {
                        let assets = responseEntity?.assets
                        if assets!.count > 0 {
                            assetDetailProtocol?.onAssetDetailSuccess(asset: assets![0])
                        } else {
                            assetDetailProtocol?.onAssetDetailError(message: "error")
                        }
                    } else {
                        assetDetailProtocol?.onAssetDetailError(message: "auth_error")
                    }
                case .failure(let error):
                    assetDetailProtocol?.onAssetDetailError(message: "network_error")
            }
        }
    }
    
}
