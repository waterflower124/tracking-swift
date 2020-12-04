//
//  GetAssetsProtocol.swift
//  NGTMobile
//
//  Created by Water Flower on 11/20/20.
//

import Foundation

protocol GetAssetsProtocol{
    
    func onGetAssetSuccess(assets: [AssetItem])
    func onGetAssetError(message: String)
    
}
