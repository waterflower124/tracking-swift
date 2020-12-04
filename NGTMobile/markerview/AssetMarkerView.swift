//
//  AssetMarkerView.swift
//  NGTMobile
//
//  Created by Water Flower on 11/25/20.
//

import UIKit

class AssetMarkerView: UIView {
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInitialization()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInitialization()
    }
    
    func commonInitialization() {
        let view = Bundle.main.loadNibNamed("AssetMarkerView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    init(image: UIImage, title: String) {
        self.init()
        iconImageView.image = image
        nameLabel.text = title
    }

}
