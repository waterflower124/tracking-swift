//
//  IntroViewController.swift
//  NGTMobile
//
//  Created by Water Flower on 11/18/20.
//

import UIKit
import SVProgressHUD
import PopupDialog

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let token = Utiles.getToken()
        if token != "" {
            Utiles.current_passed_time = Utiles.getMon_Interval()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabbarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
            self.navigationController?.pushViewController(tabbarVC, animated: true)
        }
    }
    
    @IBAction func signinButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signinVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.navigationController?.pushViewController(signinVC, animated: true)

    }
    
    

}
