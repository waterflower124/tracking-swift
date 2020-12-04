//
//  GetAssetsModel.swift
//  NGTMobile
//
//  Created by Water Flower on 11/20/20.
//

import Foundation
import Alamofire
import ObjectMapper

class GetAssetsModel: NSObject {
    
    var getAssetsProtocol: GetAssetsProtocol?
    
    public func getAssets() {
        let username = Utiles.getUsername()
        let token = Utiles.getToken()

        let param: Parameters = [
            "uid": username,
            "token": token
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
                        getAssetsProtocol?.onGetAssetSuccess(assets: assets!)
                    } else {
                        getAssetsProtocol?.onGetAssetError(message: "auth_error")
                    }
                    
                case .failure(let error):
                    print(response)
                    getAssetsProtocol?.onGetAssetError(message: "network_error")
            }
        }
    }
    
}
