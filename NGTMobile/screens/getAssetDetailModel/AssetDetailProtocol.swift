//
//  AssetDetailProtocol.swift
//  NGTMobile
//
//  Created by Water Flower on 11/30/20.
//

import Foundation

protocol AssetDetailProtocol{
    
    func onAssetDetailSuccess(asset: AssetItem)
    func onAssetDetailError(message: String)
    
}
