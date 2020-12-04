//
//  ListViewController.swift
//  NGTMobile
//
//  Created by Water Flower on 11/19/20.
//

import UIKit
import SVProgressHUD
import Alamofire
import ObjectMapper

class ListViewController: UIViewController, GetAssetsProtocol, MonitorAssetProtocol, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var filterShowButton: UIButton!
    @IBOutlet var searchUIView: UIView!
    @IBOutlet var filterUIView: UIView!
    @IBOutlet var filterAllButton: UIButton!
    @IBOutlet var filterAlertButton: UIButton!
    @IBOutlet var filterMonitoredButton: UIButton!
    @IBOutlet var filterMovingButton: UIButton!
    @IBOutlet var filterStoppedButton: UIButton!
    
    @IBOutlet var animationView: UIView!
    @IBOutlet var searchTextField: UITextField!
    
    @IBOutlet var assetListTableView: UITableView!
    
    @IBOutlet var disableMonitorView: UIView!
    @IBOutlet var disableMonitorCheckButton: UIButton!
    
    var searchText: String = ""
    var filter_value: String = "all" // all, alert, monitored, moving, stopped
    var mon_interval = 0
    
    var getAssetsModel = GetAssetsModel()
    var monitorAssetModel = MonitorAssetModel()
    
    var animationViewFrame = CGRect()
    
    var all_assets_array = [AssetItem]() // get from server
    var listAssetItems_array = [ListAssetItem]()
    var alarm_assets_array = [AssetItem]()
    var monitored_assets_array = [AssetItem]()
    var stopped_assets_array = [AssetItem]()
    var moving_assets_array = [AssetItem]()
    var idle_assets_array = [AssetItem]()
    
    var selected_asset: AssetItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAssetsModel.getAssetsProtocol = self
        monitorAssetModel.monitorAssetProtocol = self

        self.filterShowButton.layer.cornerRadius = 5
        self.searchUIView.layer.cornerRadius = 5
        self.filterUIView.layer.borderWidth = 0.5
        self.filterUIView.layer.borderColor = UIColor.black.cgColor
        
        self.filterUIView.isHidden = true
        
        self.filterAllButton.backgroundColor = UIColor(red: 44/255, green: 196/255, blue: 203/255, alpha: 0.5)
        
        mon_interval = Utiles.getMon_Interval()
        
        self.animationView?.frame = CGRect(x: 0, y: 0, width: 0, height: 3)
        
        self.assetListTableView.separatorStyle = .none
        
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
////        print("will appear function")
//        getAssetsModel.getAssets()
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.animateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
//        Utiles.current_passed_time = Int(CGFloat(self.mon_interval) * self.animationView.frame.size.width / UIScreen.main.bounds.width)
//        print(self.animationView.frame.size.width)
//        print(UIScreen.main.bounds.width)
//        print(Utiles.current_passed_time)
//        print("list view will disappear function")
        Utiles.assetItems_list = self.all_assets_array
    }
    
    func hiddenFilterUIVIew() {
        self.filterUIView.isHidden = true
    }
    
    func animateView() {
        self.animationView?.frame = CGRect(x: 0, y: 0, width: 0, height: 3)
        self.animationViewFrame = self.animationView.frame
        self.animationViewFrame.size.width = UIScreen.main.bounds.width
        
        UIView.animate(withDuration: TimeInterval(self.mon_interval - Utiles.current_passed_time), delay: 0, options: [], animations: { [self] in
            self.animationView?.frame =  self.animationViewFrame
        }, completion: { [self]_ in
            Utiles.current_passed_time = 0
            getAssetsModel.getAssets()
        })
    }
    
    @IBAction func filterShowButtonAction(_ sender: Any) {
        if self.filterUIView.isHidden {
            self.filterUIView.isHidden = false
        } else {
            self.filterUIView.isHidden = true
        }
    }
    
    @IBAction func filterButtonsAction(_ sender: UIButton) {
        
        self.filterUIView.isHidden = true
        
        if sender == self.filterAllButton {
            self.filterAllButton.backgroundColor = UIColor(red: 44/255, green: 196/255, blue: 203/255, alpha: 0.5)
            self.filterAlertButton.backgroundColor = UIColor.white
            self.filterMonitoredButton.backgroundColor = UIColor.white
            self.filterMovingButton.backgroundColor = UIColor.white
            self.filterStoppedButton.backgroundColor = UIColor.white
            if filter_value == "all" {
                return
            } else {
                filter_value = "all"
            }
        } else if sender == self.filterAlertButton {
            self.filterAllButton.backgroundColor = UIColor.white
            self.filterAlertButton.backgroundColor = UIColor(red: 44/255, green: 196/255, blue: 203/255, alpha: 0.5)
            self.filterMonitoredButton.backgroundColor = UIColor.white
            self.filterMovingButton.backgroundColor = UIColor.white
            self.filterStoppedButton.backgroundColor = UIColor.white
            if filter_value == "alert" {
                return
            } else {
                filter_value = "alert"
            }
        } else if sender == self.filterMonitoredButton {
            self.filterAllButton.backgroundColor = UIColor.white
            self.filterAlertButton.backgroundColor = UIColor.white
            self.filterMonitoredButton.backgroundColor = UIColor(red: 44/255, green: 196/255, blue: 203/255, alpha: 0.5)
            self.filterMovingButton.backgroundColor = UIColor.white
            self.filterStoppedButton.backgroundColor = UIColor.white
            if filter_value == "monitored" {
                return
            } else {
                filter_value = "monitored"
            }
        } else if sender == self.filterMovingButton {
            self.filterAllButton.backgroundColor = UIColor.white
            self.filterAlertButton.backgroundColor = UIColor.white
            self.filterMonitoredButton.backgroundColor = UIColor.white
            self.filterMovingButton.backgroundColor = UIColor(red: 44/255, green: 196/255, blue: 203/255, alpha: 0.5)
            self.filterStoppedButton.backgroundColor = UIColor.white
            if filter_value == "moving" {
                return
            } else {
                filter_value = "moving"
            }
        } else if sender == self.filterStoppedButton {
            self.filterAllButton.backgroundColor = UIColor.white
            self.filterAlertButton.backgroundColor = UIColor.white
            self.filterMonitoredButton.backgroundColor = UIColor.white
            self.filterMovingButton.backgroundColor = UIColor.white
            self.filterStoppedButton.backgroundColor = UIColor(red: 44/255, green: 196/255, blue: 203/255, alpha: 0.5)
            if filter_value == "stopped" {
                return
            } else {
                filter_value = "stopped"
            }
        }
        
        self.arrangeAssetsArray()
        self.assetListTableView.reloadData()
        
    }
    
    @IBAction func disableMonitorCheckButtonAction(_ sender: Any) {
        if Utiles.getMonitorToggleValue() == "yes" {
            Utiles.saveMonotorToggleDialogShowSetting(value: "no")
            self.disableMonitorCheckButton.setImage(UIImage(named: "uncheckedbox.png"), for: .normal)
        } else {
            Utiles.saveMonotorToggleDialogShowSetting(value: "yes")
            self.disableMonitorCheckButton.setImage(UIImage(named: "checkedbox.png"), for: .normal)
        }
    }
    
    @IBAction func disablMonitorDialogYesButtonAction(_ sender: Any) {
        SVProgressHUD.show()
        monitorAssetModel.toggleMonitorAsset(toggled_asset: self.selected_asset, mon_interval: 0, mon_starttime: "", mon_stoptime: "")
    }
    
    @IBAction func disableMonitorDialogNoButtonAction(_ sender: Any) {
        Utiles.saveMonotorToggleDialogShowSetting(value: "no")
        self.disableMonitorView.isHidden = true
    }
    
    func onGetAssetSuccess(assets: [AssetItem]) {
//        print(assets)
        self.all_assets_array = assets
        
        self.arrangeAssetsArray()
        self.assetListTableView.reloadData()
        self.animateView()
    }
    
    func onGetAssetError(message: String) {
        print(message)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.searchText = textField.text ?? ""
        self.arrangeAssetsArray()
        self.assetListTableView.reloadData()
        print("--------\(searchText)")
    }
    
    func arrangeAssetsArray() {
        self.monitored_assets_array.removeAll()
        self.alarm_assets_array.removeAll()
        self.stopped_assets_array.removeAll()
        self.moving_assets_array.removeAll()
        self.idle_assets_array.removeAll()
        
        for item in all_assets_array {
            if item.a_alarm == "1" {
                if self.filter_value == "all" || self.filter_value == "alert" {
                    if self.searchText == "" {
                        self.alarm_assets_array.append(item)
                    } else {
                        if item.a_name?.lowercased().range(of: self.searchText.lowercased()) != nil ||
                            item.a_loc?.lowercased().range(of: self.searchText.lowercased()) != nil  {
                            self.alarm_assets_array.append(item)
                        }
                    }
                }
            } else if item.a_mon == "1" {
                if self.filter_value == "all" || self.filter_value == "monitored" {
                    if self.searchText == "" {
                        self.monitored_assets_array.append(item)
                    } else {
                        
                        if item.a_name?.lowercased().range(of: self.searchText.lowercased()) != nil ||
                            item.a_loc?.lowercased().range(of: self.searchText.lowercased()) != nil {
                            self.monitored_assets_array.append(item)
                        }
                    }
                }
            } else if item.a_stat == "1" {
                if self.filter_value == "all" || self.filter_value == "moving" {
                    if self.searchText == "" {
                        self.moving_assets_array.append(item)
                    } else {
                        if item.a_name?.lowercased().range(of: self.searchText.lowercased()) != nil ||
                            item.a_loc?.lowercased().range(of: self.searchText.lowercased()) != nil {
                            self.moving_assets_array.append(item)
                        }
                    }
                }
            } else if item.a_stat == "0" {
                if self.filter_value == "all" || self.filter_value == "stopped" {
                    if self.searchText == "" {
                        self.stopped_assets_array.append(item)
                    } else {
                        if item.a_name?.lowercased().range(of: self.searchText.lowercased()) != nil ||
                            item.a_loc?.lowercased().range(of: self.searchText.lowercased()) != nil {
                            self.stopped_assets_array.append(item)
                        }
                    }
                }
            }
//            else if item.a_stat == "2" {
//                if self.filter_value == "all" || self.filter_value == "idle" {
//                    if self.searchText == "" {
//                        self.idle_assets_array.append(item)
//                    } else {
//                        if ((item.a_name?.lowercased().contains(self.searchText.lowercased())) != nil) {
//                            self.idle_assets_array.append(item)
//                        }
//                    }
//                }
//
//            }
        }
        
        self.listAssetItems_array.removeAll()
        if self.alarm_assets_array.count > 0 {
            self.listAssetItems_array.append(ListAssetItem.init(a_status: "ALERT", assetItems: self.alarm_assets_array))
        }
        if self.monitored_assets_array.count > 0 {
            self.listAssetItems_array.append(ListAssetItem.init(a_status: "MONITORED", assetItems: self.monitored_assets_array))
        }
        if self.moving_assets_array.count > 0 {
            self.listAssetItems_array.append(ListAssetItem.init(a_status: "MOVING", assetItems: self.moving_assets_array))
        }
        if self.stopped_assets_array.count > 0 {
            self.listAssetItems_array.append(ListAssetItem.init(a_status: "STOPPED", assetItems: self.stopped_assets_array))
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.listAssetItems_array.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("AssetListTableViewCellHeader", owner: self, options: nil)?.first as! AssetListTableViewCellHeader
        headerView.statusLabel.text = self.listAssetItems_array[section].a_status
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listAssetItems_array[section].assetItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell select")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssetListTableViewCell") as! AssetListTableViewCell
        cell.selectionStyle = .none
        let asset = self.listAssetItems_array[indexPath.section].assetItems![indexPath.row]
        cell.assetNameLabel.text = asset.a_name
        cell.assetAddressLabel.text = asset.a_loc
        if asset.notification_count == 0 {
            cell.alertView.isHidden = true
        } else {
            cell.alertCountLabel.text = String(asset.notification_count ?? 0)
            cell.alertView.isHidden = false
        }
        
        if asset.a_alarm == "1" {
            if asset.a_type?.lowercased() == "truck" {
                cell.statusImageView.image = UIImage(named: "truck_red.png")
            } else if asset.a_type?.lowercased() == "car" {
                cell.statusImageView.image = UIImage(named: "car_red.png")
            } else if asset.a_type?.lowercased() == "motorcycle" {
                cell.statusImageView.image = UIImage(named: "motorcycle_red.png")
            } else if asset.a_type?.lowercased() == "person" {
                cell.statusImageView.image = UIImage(named: "person_red.png")
            } else if asset.a_type?.lowercased() == "genset" {
                cell.statusImageView.image = UIImage(named: "genset_red.png")
            } else if asset.a_type?.lowercased() == "bus" {
                cell.statusImageView.image = UIImage(named: "bus_red.png")
            } else {
                cell.statusImageView.image = UIImage(named: "others_red.png")
            }
        } else if asset.a_stat == "0" { // stop
            if asset.a_type?.lowercased() == "truck" {
                cell.statusImageView.image = UIImage(named: "truck_grey.png")
            } else if asset.a_type?.lowercased() == "car" {
                cell.statusImageView.image = UIImage(named: "car_grey.png")
            } else if asset.a_type?.lowercased() == "motorcycle" {
                cell.statusImageView.image = UIImage(named: "motorcycle_grey.png")
            } else if asset.a_type?.lowercased() == "person" {
                cell.statusImageView.image = UIImage(named: "person_grey.png")
            } else if asset.a_type?.lowercased() == "genset" {
                cell.statusImageView.image = UIImage(named: "genset_grey.png")
            } else if asset.a_type?.lowercased() == "bus" {
                cell.statusImageView.image = UIImage(named: "bus_grey.png")
            } else {
                cell.statusImageView.image = UIImage(named: "others_grey.png")
            }
        } else if asset.a_stat == "1" { // moving
            if asset.a_type?.lowercased() == "truck" {
                cell.statusImageView.image = UIImage(named: "truck_green.png")
            } else if asset.a_type?.lowercased() == "car" {
                cell.statusImageView.image = UIImage(named: "car_green.png")
            } else if asset.a_type?.lowercased() == "motorcycle" {
                cell.statusImageView.image = UIImage(named: "motorcycle_green.png")
            } else if asset.a_type?.lowercased() == "person" {
                cell.statusImageView.image = UIImage(named: "person_green.png")
            } else if asset.a_type?.lowercased() == "genset" {
                cell.statusImageView.image = UIImage(named: "genset_green.png")
            } else if asset.a_type?.lowercased() == "bus" {
                cell.statusImageView.image = UIImage(named: "bus_green.png")
            } else {
                cell.statusImageView.image = UIImage(named: "others_green.png")
            }
        } else if asset.a_stat == "2" { // moving
            if asset.a_type?.lowercased() == "truck" {
                cell.statusImageView.image = UIImage(named: "truck_yellow.png")
            } else if asset.a_type?.lowercased() == "car" {
                cell.statusImageView.image = UIImage(named: "car_yellow.png")
            } else if asset.a_type?.lowercased() == "motorcycle" {
                cell.statusImageView.image = UIImage(named: "motorcycle_yellow.png")
            } else if asset.a_type?.lowercased() == "person" {
                cell.statusImageView.image = UIImage(named: "person_yellow.png")
            } else if asset.a_type?.lowercased() == "genset" {
                cell.statusImageView.image = UIImage(named: "genset_yellow.png")
            } else if asset.a_type?.lowercased() == "bus" {
                cell.statusImageView.image = UIImage(named: "bus_yellow.png")
            } else {
                cell.statusImageView.image = UIImage(named: "others_yellow.png")
            }
        } else {
            cell.statusImageView.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        }
        
        cell.changeMonitorSetting = {
            self.selected_asset = asset
            if asset.a_mon == "1" {
                if Utiles.getMonitorToggleValue() == "no" {
                    self.disableMonitorView.isHidden = false
                } else {
                    SVProgressHUD.show()
                    self.monitorAssetModel.toggleMonitorAsset(toggled_asset: self.selected_asset, mon_interval: 0, mon_starttime: "", mon_stoptime: "")
                }
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let monotoringVC = storyboard.instantiateViewController(withIdentifier: "EnableMonitoringViewController") as! EnableMonitoringViewController
                monotoringVC.selected_asset = asset
                self.navigationController?.pushViewController(monotoringVC, animated: true)
            }
        }
        cell.gotoMapList = {
            if let mapVC = self.tabBarController?.viewControllers?[1] as? MapViewController {
                mapVC.selected_asset = asset
                mapVC.all_assets_array = self.all_assets_array
                mapVC.first_open = true
                mapVC.asset_info_show = true
                mapVC.detail_info_show = false
                mapVC.shown_category = "info"
                mapVC.selected_trip_date = Date()
            }
            self.tabBarController?.selectedIndex = 1
        }
        cell.eraseAlert = {
            var success = false
            for list_item in self.listAssetItems_array {
                let assets_item_array = list_item.assetItems ?? []
                for assets_item in assets_item_array {
                    if assets_item.a_id == asset.a_id {
                        asset.notification_count = 0
                        success = true
                        break;
                    }
                }
                if success {
                    break
                }
            }
            self.assetListTableView.reloadData()
        }
         
        return cell
    }

    
    func onMonitorAssetSuccess(message: String) {
        getAssetsModel.getAssets()
        SVProgressHUD.dismiss()
    }
    
    func onMonitorAssetError(message: String) {
        print(message)
        SVProgressHUD.dismiss()
        if message == "auth_error" {
            
        } else if message == "network_error" {
            
        }
    }
    


}
