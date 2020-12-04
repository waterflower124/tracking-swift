//
//  SettingsViewController.swift
//  NGTMobile
//
//  Created by Water Flower on 11/24/20.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var dialogSettingView: UIView!
    @IBOutlet var notificationSettingView: UIView!
    @IBOutlet var notificationLabel: UILabel!
    @IBOutlet var dialogView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.dialogSettingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(self.showDialogSettingView)))
        self.notificationSettingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(self.showNotificationSettingView)))
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func showDialogSettingView(sender : UITapGestureRecognizer) {
        self.dialogView.isHidden = false
    }
    
    @objc func showNotificationSettingView(sender : UITapGestureRecognizer) {
        // Do what you want
    }
    
    @IBAction func dialogSettingYesButtonAction(_ sender: Any) {
        self.dialogView.isHidden = true
    }
    
    @IBAction func dialogSettingNoButtonAction(_ sender: Any) {
        self.dialogView.isHidden = true
    }
}
