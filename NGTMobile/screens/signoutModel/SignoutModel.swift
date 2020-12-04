//
//  SignoutModel.swift
//  NGTMobile
//
//  Created by Water Flower on 11/20/20.
//

import Foundation
import Alamofire
import ObjectMapper

class SignoutModel: NSObject {
    
    var signoutProtocal: SignoutProtocal?
    
    public func signout() {
        let username = Utiles.getUsername()
        let token = Utiles.getToken()
        let param: Parameters = [
            "uid": username,
            "pwd": token
        ]
        AF.request(Constant.BASE_URL + "/requestSignOut", method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON{ [self]
            response in
//            print(response)
            
            switch response.result {
                case .success(let value):
                    signoutProtocal?.onSignoutSuccess()
                case .failure(let error):
                    signoutProtocal?.onSignoutError()
            }

        }
    }
    
}
