//
//  Utiles.swift
//  NGTMobile
//
//  Created by Water Flower on 11/19/20.
//

import Foundation
import SwiftyJSON
import ObjectMapper

class Utiles : NSObject
{
    
    static var current_passed_time: Int = 0 //  for animated uiview
    static var assetItems_list: [AssetItem]!
    
    public class func showAlert( title: String, message: String, parent: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {[unowned parent] action in
            parent.dismiss(animated: true, completion: nil)
        }))
        
        parent.present(alert, animated: true, completion: nil)
    }
    
    public class func saveToken(token: String){
        let userDefaults = UserDefaults()
        userDefaults.set(token, forKey: Constant.USERTOKEN)
    }
    
    public class func getToken() -> String {
        let userDefaults = UserDefaults()
        if let token = userDefaults.string(forKey: Constant.USERTOKEN) {
            return token
        } else {
            return ""
        }
    }
    
    public class func saveGroupDistance(distance: String){
        let userDefaults = UserDefaults()
        userDefaults.set(distance, forKey: Constant.GROUP_DISTANCE)
    }
    
    public class func getGroupDistance() -> Float {
        let userDefaults = UserDefaults()
        if let distance = userDefaults.string(forKey: Constant.GROUP_DISTANCE) {
            return Float(distance)!
        } else {
            return 0
        }
    }
    
    public class func saveMon_Interval(interval: String){
        let userDefaults = UserDefaults()
        userDefaults.set(interval, forKey: Constant.MONINTERVAL)
    }
    
    public class func getMon_Interval() -> Int {
        let userDefaults = UserDefaults()
        if let interval_str = userDefaults.string(forKey: Constant.MONINTERVAL) {
            return Int(interval_str)!
        } else {
            return 10
        }
    }
    
    public class func saveAutoSignout(value: String){
        let userDefaults = UserDefaults()
        userDefaults.set(value, forKey: Constant.AUTO_SIGNOUT)
    }
    
    public class func getAutoSignout() -> String {
        let userDefaults = UserDefaults()
        if let value = userDefaults.string(forKey: Constant.AUTO_SIGNOUT) {
            return value
        } else {
            return "no"
        }
    }
    
    public class func saveUsername(username: String){
        let userDefaults = UserDefaults()
        userDefaults.set(username, forKey: Constant.USERNAME)
    }
    
    public class func getUsername() -> String {
        let userDefaults = UserDefaults()
        if let username = userDefaults.string(forKey: Constant.USERNAME) {
            return username
        } else {
            return ""
        }
    }
    
    public class func saveMonotorToggleDialogShowSetting(value: String){
        let userDefaults = UserDefaults()
        userDefaults.set(value, forKey: Constant.MONITOR_TOGGLE)
    }
    
    public class func getMonitorToggleValue() -> String {
        let userDefaults = UserDefaults()
        if let value = userDefaults.string(forKey: Constant.MONITOR_TOGGLE) {
            return value
        } else {
            return "no"
        }
    }
    
    public class func saveAssetCardTypes(value: [AssetCardTypeItem]) {
        let userDefaults = UserDefaults()
        do {
            let arrayData = try JSONEncoder().encode(value)
            userDefaults.set(arrayData, forKey: Constant.ASSET_CARD_TYPE)
        } catch {
            
        }
    }
    
    public class func getAssetCardTypes() -> [AssetCardTypeItem] {
        let userDefaults = UserDefaults()
        if let value = userDefaults.data(forKey: Constant.ASSET_CARD_TYPE) {
            do {
                let card_type_array = try JSONDecoder().decode([AssetCardTypeItem].self, from: value)
                return card_type_array
            } catch {
                return []
            }
        } else {
            return []
        }
    }
    
    public class func clearAllData(){
        let userDefaults = UserDefaults()
        userDefaults.removeObject(forKey: Constant.USERTOKEN)
    }
    
    public class func getCardType(assetCardValue: AssetCardValueItems) -> AssetCardTypeItem {
        let all_card_types: [AssetCardTypeItem] = getAssetCardTypes()
        var return_value: AssetCardTypeItem!
        for card_type in all_card_types {
            if card_type.a_card_no == assetCardValue.a_card_no {
                return_value = card_type
                break
            }
        }
        return return_value
    }
    
    public class func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }

        if (cString.count != 6) {
            return UIColor.gray
        }

        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)

        var r: UInt64 = 0, g: UInt64 = 0, b: UInt64 = 0;
        Scanner(string: rString).scanHexInt64(&r)
        Scanner(string: gString).scanHexInt64(&g)
        Scanner(string: bString).scanHexInt64(&b)


        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    public class func timeConverter(time_string: String)-> String {
        if let time_second = Int(time_string) {
            let hour = time_second / 3600
            let minute = (time_second % 3600) / 60
            var return_string = ""
            if hour > 0 {
                return_string += "\(hour)h "
            }
            if minute > 0 {
                return_string += "\(minute)m"
            }
            if hour == 0 && minute == 0 {
                return_string = "\(time_second)s"
            }
            return return_string
        } else {
            return "0s"
        }
    }
}
