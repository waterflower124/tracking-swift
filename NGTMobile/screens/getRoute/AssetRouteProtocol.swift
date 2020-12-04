//
//  AssetRouteProtocol.swift
//  NGTMobile
//
//  Created by Water Flower on 12/1/20.
//

import Foundation

protocol AssetRouteProtocol{
    
    func onAssetRouteSuccess(routes: [AssetRouteItem])
    func onAssetRouteError(message: String)
    
}

