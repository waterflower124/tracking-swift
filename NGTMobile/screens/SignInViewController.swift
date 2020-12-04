//
//  SignInViewController.swift
//  NGTMobile
//
//  Created by Water Flower on 11/19/20.
//

import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD

class SignInViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signinButtonAction(_ sender: Any) {
        let username = self.usernameTextField.text!
        let password = self.passwordTextField.text!
        if username == "" || password == "" {
            Utiles.showAlert(title: "Warnning!", message: "Please input Username and Password", parent: self)
            return
        }
        
        SVProgressHUD.show()
        let param: Parameters = [
            "uid": username,
            "pwd": password
        ]
        AF.request(Constant.BASE_URL + "/requestSignIn", method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON{
            response in
//            print(response)
            
            switch response.result {
                case .success(let value):
                    let jsonResponse = value as! NSDictionary
                    let responseEntity = Mapper<SignInResponse>().map(JSONObject: jsonResponse)
                    let status = responseEntity?.status
                    if status == "1" {
                        Utiles.saveUsername(username: username)
                        let token = responseEntity?.token
                        Utiles.saveToken(token: token!)
                        let group_distance = responseEntity?.group_distance
                        Utiles.saveGroupDistance(distance: group_distance!)
                        let mon_interval = responseEntity?.update_int
                        Utiles.saveMon_Interval(interval: mon_interval!)
                        let card_type_array = responseEntity?.asset_card_type
                        Utiles.saveAssetCardTypes(value: card_type_array ?? [])
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                        self.navigationController?.pushViewController(tabbarVC, animated: true)
                    } else {
                        
                    }
//                    if let jsonObj = value as? Dictionary<String, Any> {
//                        let status = jsonObj["status"]! as? String ?? ""
//                        if status == "1" {
//                            Utiles.saveUsername(username: username)
//                            let token = jsonObj["token"]! as? String
//
//                            Utiles.saveToken(token: token!)
//                            let group_distance = jsonObj["group_distance"]! as? String
//                            Utiles.saveGroupDistance(distance: group_distance!)
//                            let mon_interval = jsonObj["update_int"]! as? String
//
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            let tabbarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
//                            self.navigationController?.pushViewController(tabbarVC, animated: true)
//                        } else {
//
//                        }
//                    }
                case .failure(let error):
                    print(error)
            }
            SVProgressHUD.dismiss()

        }
    }

    
    
}
