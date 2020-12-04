//
//  AssetTripProtocol.swift
//  NGTMobile
//
//  Created by Water Flower on 11/30/20.
//

import Foundation

protocol AssetTripProtocol{
    
    func onAssetTripSuccess(trips: [AssetTripItem])
    func onAssetTripError(message: String)
    
}

