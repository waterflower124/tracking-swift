//
//  AssetListTableViewCell.swift
//  NGTMobile
//
//  Created by Water Flower on 11/24/20.
//

import UIKit

class AssetListTableViewCell: UITableViewCell {

    @IBOutlet var statusImageView: UIImageView!
    @IBOutlet var assetNameLabel: UILabel!
    @IBOutlet var assetAddressLabel: UILabel!
    @IBOutlet var alertView: UIView!
    @IBOutlet var alertCountLabel: UILabel!
    @IBOutlet var alertCountView: UIView!
    
    var changeMonitorSetting: (() -> Void)? = nil
    var gotoMapList: (() -> Void)? = nil
    var eraseAlert: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.alertCountView.layer.cornerRadius = 15 / 2
        self.statusImageView.layer.cornerRadius = 35 / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func statusButtonAction(_ sender: Any) {
        changeMonitorSetting?()
    }
    
    @IBAction func mainButtonAction(_ sender: Any) {
        gotoMapList?()
    }
    
    @IBAction func bellButtonAction(_ sender: Any) {
        eraseAlert?()
    }
}
