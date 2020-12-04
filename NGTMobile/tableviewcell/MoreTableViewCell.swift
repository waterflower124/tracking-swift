//
//  MoreTableViewCell.swift
//  NGTMobile
//
//  Created by Water Flower on 11/30/20.
//

import UIKit

class MoreTableViewCell: UITableViewCell {
    
    @IBOutlet var outerView: UIView!
    @IBOutlet var innerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var seqView: UIView!
    @IBOutlet var seqLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        outerView.layer.cornerRadius = 5
        outerView.layer.borderWidth = 1
        outerView.layer.borderColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1).cgColor
        innerView.layer.cornerRadius = 5
        seqView.layer.cornerRadius = 25 / 2
        seqView.layer.borderColor = UIColor.black.cgColor
        seqView.layer.borderWidth = 0.5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
