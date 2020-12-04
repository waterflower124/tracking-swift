//
//  ConfirmPopupViewController.swift
//  NGTMobile
//
//  Created by Water Flower on 11/20/20.
//

import UIKit
import SVProgressHUD

class ConfirmPopupViewController: UIViewController, SignoutProtocal {

    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var checkBoxButton: UIButton!
    
    
    var type: String = ""
    var auto_signout = false
    
    var signoutModel = SignoutModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signoutModel.signoutProtocal = self
        
        if type == "signout" {
            messageLabel.text = "By signin out, all monitored assets notification will stop until you re-sign in again.\nWarning: Alerts and notifications history will be deleted upon sign out."
        }
        
    }
    
    @IBAction func checkBoxButtonAction(_ sender: Any) {
        self.auto_signout = !self.auto_signout
        if self.auto_signout {
            self.checkBoxButton.setImage(UIImage(named: "checkedbox.png"), for: .normal)
        } else {
            self.checkBoxButton.setImage(UIImage(named: "uncheckedbox.png"), for: .normal)
        }
    }
    
    @IBAction func yesButtonAction(_ sender: Any) {
        SVProgressHUD.show()
        signoutModel.signout()

    }
    
    @IBAction func noButtonAction(_ sender: Any) {
        Utiles.saveAutoSignout(value: "no")
        
    }
    
    func onSignoutSuccess() {
        print("success")
        SVProgressHUD.dismiss()
        if self.auto_signout {
            Utiles.saveAutoSignout(value: "yes")
        } else {
            Utiles.saveAutoSignout(value: "no")
        }
        Utiles.clearAllData()
        dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name("signout"), object: nil)
        })
    }
    
    func onSignoutError() {
        print("error")
        SVProgressHUD.dismiss()
        Utiles.showAlert(title: "Warning!", message: "There is an error. Please try again", parent: self)
        
    }
}
