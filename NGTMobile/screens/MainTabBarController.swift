//
//  MainTabBarController.swift
//  NGTMobile
//
//  Created by Water Flower on 11/19/20.
//

import UIKit
import PopupDialog
import SVProgressHUD

class MainTabBarController: UITabBarController, UITabBarControllerDelegate, SignoutProtocal {
    
    
    var settingUIView_shown: Bool = false
    var settingUIView: UIView = UIView()
    
    let settingUIViewWidth: CGFloat = 200
    let settingUIViewHeight: CGFloat = 100
    
    var signoutModel = SignoutModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        signoutModel.signoutProtocal = self
        
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: 48)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor(red: 44/255, green: 196/255, blue: 203/255, alpha: 0.5), size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)

        // remove default border
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -2
        
        let topSafeArea: CGFloat
        let bottomSafeArea: CGFloat

        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
            bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
        }
        
        let tabbarHeight = self.tabBarController?.tabBar.frame.size.height ?? 49
        
        settingUIView.frame = CGRect(x: self.view.frame.width - self.settingUIViewWidth, y: self.view.frame.height - self.settingUIViewHeight - bottomSafeArea - tabbarHeight, width: self.settingUIViewWidth, height: self.settingUIViewHeight)
        settingUIView.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        
        // signout sub view
        let signoutView = UIView(frame: CGRect(x: 0, y: 0, width: self.settingUIViewWidth, height: self.settingUIViewHeight / 2))
        let signoutImageView = UIImageView(image: UIImage(named: "signout.png")!)
        signoutImageView.frame = CGRect(x: self.settingUIViewWidth - 40, y: (self.settingUIViewHeight / 2 - 20) / 2, width: 20, height: 20)
        signoutView.addSubview(signoutImageView)
        let signoutLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.settingUIViewWidth - 60, height: self.settingUIViewHeight / 2))
        signoutLabel.text = "SIGN OUT"
        signoutLabel.font = UIFont(name:"Roboto-Medium", size: 12)
        signoutLabel.textAlignment = .right
        signoutView.addSubview(signoutLabel)
        let signoutButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.settingUIViewWidth, height: self.settingUIViewHeight))
        signoutButton.addTarget(self, action: #selector(signout), for: .touchUpInside)
        signoutView.addSubview(signoutButton)
        
        // settings sub view
        let settingsView = UIView(frame: CGRect(x: 0, y: self.settingUIViewHeight / 2, width: self.settingUIViewWidth, height: self.settingUIViewHeight / 2))
        let settingsImageView = UIImageView(image: UIImage(named: "settings.png")!)
        settingsImageView.frame = CGRect(x: self.settingUIViewWidth - 40, y: (self.settingUIViewHeight / 2 - 20) / 2, width: 20, height: 20)
        settingsView.addSubview(settingsImageView)
        let settingsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.settingUIViewWidth - 60, height: self.settingUIViewHeight / 2))
        settingsLabel.text = "SETTINGS"
        settingsLabel.font = UIFont(name:"Roboto-Medium", size: 12)
        settingsLabel.textAlignment = .right
        settingsView.addSubview(settingsLabel)
        let settingsButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.settingUIViewWidth, height: self.settingUIViewHeight))
        settingsButton.addTarget(self, action: #selector(gotoSetting), for: .touchUpInside)
        settingsView.addSubview(settingsButton)
        
        // add subview
        self.settingUIView.addSubview(signoutView)
        self.settingUIView.addSubview(settingsView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationObserver), name: Notification.Name("signout"), object: nil)
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let listVC = viewController as? ListViewController {
            listVC.hiddenFilterUIVIew()
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers?[3] {
            if settingUIView_shown {
                self.settingUIView.removeFromSuperview()
                settingUIView_shown = false
            } else {
                self.view.addSubview(settingUIView)
                settingUIView_shown = true
            }
            return false
        } else {
            if settingUIView_shown {
                self.settingUIView.removeFromSuperview()
                settingUIView_shown = false
            }
            return true
        }
    }
    
    @objc func notificationObserver() {
        onSignoutSuccess()
    }
    
    @objc func signout() {
        
        self.settingUIView.removeFromSuperview()
        settingUIView_shown = false
        
//        let auto_signout = Utiles.getAutoSignout()
//        if auto_signout == "yes" {
//            SVProgressHUD.show()
//            signoutModel.signout()
//        } else {
//
//        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ConfirmPopupViewController") as! ConfirmPopupViewController
        vc.type = "signout"
        // Create thec  dialog
        let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
    @objc func gotoSetting() {
        print("gotoSetting")
        self.settingUIView.removeFromSuperview()
        settingUIView_shown = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func onSignoutSuccess() {
        print("success")
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        Utiles.clearAllData()
        self.navigationController?.popViewController(animated: true)
    }
    
    func onSignoutError() {
        print("error")
        SVProgressHUD.dismiss()
        
        Utiles.showAlert(title: "Warning!", message: "There is an error. Please try again", parent: self)
    }

}
