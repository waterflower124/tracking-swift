//
//  TripTableViewCell.swift
//  NGTMobile
//
//  Created by Water Flower on 11/30/20.
//

import UIKit

class TripTableViewCell: UITableViewCell {

    @IBOutlet var outerView: UIView!
    @IBOutlet var innerView: UIView!
    @IBOutlet var stopTimeLabel: UILabel!
    @IBOutlet var stopAALabel: UILabel!
    @IBOutlet var lastStatusLabel: UILabel!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var startAALabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var stopLocLabel: UILabel!
    @IBOutlet var startLocLabel: UILabel!
    @IBOutlet var driveLabel: UILabel!
    
    @IBOutlet var prevStartImageView: UIImageView!
    @IBOutlet var idleTimeLabel: UILabel!
    @IBOutlet var counterView: UIView!
    @IBOutlet var counterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerView.layer.cornerRadius = 5
        outerView.layer.borderWidth = 1
        outerView.layer.borderColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1).cgColor
        innerView.layer.cornerRadius = 5
        counterView.layer.cornerRadius = 25 / 2
        counterView.layer.borderColor = UIColor.black.cgColor
        counterView.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
