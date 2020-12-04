//
//  AssetCardTypeACollectionViewCell.swift
//  NGTMobile
//
//  Created by Water Flower on 11/30/20.
//

import UIKit

class AssetCardTypeACollectionViewCell: UICollectionViewCell {

    @IBOutlet var outerView: UIView!
    @IBOutlet var innerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var item1Label: UILabel!
    @IBOutlet var noteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        outerView.layer.cornerRadius = 5
        outerView.layer.borderWidth = 1
        outerView.layer.borderColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1).cgColor
        innerView.layer.cornerRadius = 5
    }

}
