//
//  MapViewController.swift
//  NGTMobile
//
//  Created by Water Flower on 11/19/20.
//

import UIKit
import SVProgressHUD
import Alamofire
import ObjectMapper
import GoogleMaps
import MapKit

class MapViewController: UIViewController, GetAssetsProtocol, AssetDetailProtocol, AssetTripProtocol, AssetRouteProtocol, UITextFieldDelegate, GMSMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet var searchUIView: UIView!
    @IBOutlet var filterShowButton: UIButton!
    @IBOutlet var filterUIView: UIView!
    @IBOutlet var filterAllButton: UIButton!
    @IBOutlet var filterAlertButton: UIButton!
    @IBOutlet var filterMonitoredButton: UIButton!
    @IBOutlet var filterMovingButton: UIButton!
    @IBOutlet var filterStoppedButton: UIButton!
    @IBOutlet var animationView: UIView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var toggleButtonView: UIView!
    @IBOutlet var mapSettingView: UIView!
    @IBOutlet var mapLabelSettingButton: UIButton!
    @IBOutlet var mapTrafficSettingButton: UIButton!
    @IBOutlet var mapSatelliteSettingButton: UIButton!
    
    @IBOutlet var mainMapView: GMSMapView!
    
    @IBOutlet var assetInfoDetailView: UIView!
    @IBOutlet var infoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var infoTopView: UIView!
    @IBOutlet var infoDetailViewToggleButton: UIButton!
    @IBOutlet var assetInfoNameLabel: UILabel!
    @IBOutlet var assetInfoUserLabel: UILabel!
    @IBOutlet var assetInfoAddrLabel: UILabel!
    @IBOutlet var assetInfoStatusLabel: UILabel!
    @IBOutlet var assetInfoUpdateLabel: UILabel!
    
    @IBOutlet var infoCategoryView: UIView!
    @IBOutlet var infoButtonBottomLine: UIView!
    @IBOutlet var tripButtonBottomLine: UIView!
    @IBOutlet var moreButtomBottomLine: UIView!
    
    @IBOutlet var infoView: UIView!
    @IBOutlet var tripsView: UIView!
    @IBOutlet var moreView: UIView!
    
    @IBOutlet var infoCollectionView: UICollectionView!
    @IBOutlet var moreTableView: UITableView!
    @IBOutlet var tripTableView: UITableView!
    
    @IBOutlet var tripDateLabel: UILabel!
    
    @IBOutlet var modalView: UIView!
    @IBOutlet var tripDatePicker: UIDatePicker!
    
    @IBOutlet var assetSearchResultView: UIView!
    @IBOutlet var assetListTableView: UITableView!
    
    var assetSearchText: String = ""
    var selected_asset: AssetItem!
    var filter_value: String = "all" // all, alert, monitored, moving, stopped
    var mon_interval = 0
    
    var animationViewFrame = CGRect()
    
    var getAssetsModel = GetAssetsModel()
    var getAssetDetailModel = AssetDetailModel()
    var getAssetTripModel = AssetTripModel()
    var getAssetRouteModel = AssetRouteModel()
    
    var first_open = true
    
    var map_label_setting = 1 // 0: off, 1: on
    var map_traffic_setting = 0 // 0: off, 1: on
    var map_satellite_setting = 0 // 0: off, 1: on
    
    var all_assets_array: [AssetItem] = [] // get from server
    
    let DEFAULT_ZOOM:Float = 18.0
    
    var safearea_height = 0
    var asset_info_show = false // shows top info view of selected asset
    var detail_info_show = false // shows detail of selected asset
    
    var shown_category = "info" // info, trips, more
    
    var dateFormatter: DateFormatter!
    
    var info_array: [AssetCardValueItems] = []
    var more_array: [AssetMoreItems] = []
    var trip_array: [AssetTripItem] = []
    var route_array: [AssetRouteItem] = []
    
    var selected_trip_date = Date()
    
    var polyline: GMSPolyline = GMSPolyline()
    
    // for search asset
    var listAssetItems_array = [ListAssetItem]()
    var alarm_assets_array = [AssetItem]()
    var monitored_assets_array = [AssetItem]()
    var stopped_assets_array = [AssetItem]()
    var moving_assets_array = [AssetItem]()
    var idle_assets_array = [AssetItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getAssetsModel.getAssetsProtocol = self
        getAssetDetailModel.assetDetailProtocol = self
        getAssetTripModel.assetTripProtocol = self
        getAssetRouteModel.assetRouteProtocol = self
        
        self.filterShowButton.layer.cornerRadius = 5
        self.searchUIView.layer.cornerRadius = 5
        self.filterUIView.layer.borderWidth = 0.5
        self.filterUIView.layer.borderColor = UIColor.black.cgColor
        
        self.filterAllButton.backgroundColor = UIColor(red: 44/255, green: 196/255, blue: 203/255, alpha: 0.5)
        
        self.toggleButtonView.layer.cornerRadius = 40 / 2
        self.mapSettingView.layer.cornerRadius = 40 / 2
        
        mon_interval = Utiles.getMon_Interval()
        
        self.animationView?.frame = CGRect(x: 0, y: 0, width: 0, height: 3)
        
//        mainMapView.settings.myLocationButton = true
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.tappedDetailTopView))
        self.infoTopView.addGestureRecognizer(gesture)
        
        self.moreTableView.separatorStyle = .none
        self.tripTableView.separatorStyle = .none
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        self.infoCollectionView.register(UINib(nibName: "AssetCardTypeACollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AssetCardTypeACollectionViewCell")
        self.infoCollectionView.register(UINib(nibName: "AssetCardTypeBCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AssetCardTypeBCollectionViewCell")
        self.infoCollectionView.register(UINib(nibName: "AssetCardTypeCCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AssetCardTypeCCollectionViewCell")
        
        self.polyline.strokeColor = UIColor(red: 20/255, green: 114/255, blue: 255/255, alpha: 1)
        self.polyline.strokeWidth = 5
        
    }
    
    @objc func tappedDetailTopView() {
        self.toggleDetailView()
    }

    override func viewDidLayoutSubviews() {
        self.safearea_height = Int(UIScreen.main.bounds.height - (view.safeAreaInsets.top + view.safeAreaInsets.bottom) - 15)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.animateView()
        if self.first_open {
            self.first_open = false
            if self.selected_asset != nil {
                showMarkers(all_assets: self.all_assets_array)
                let lat_first:Double = Double(self.selected_asset.a_lat!) ?? 0
                let lng_first:Double = Double(self.selected_asset.a_lon!) ?? 0
                let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: lat_first, longitude: lng_first), zoom: DEFAULT_ZOOM)
                self.mainMapView.camera = camera
                
                if self.asset_info_show {
                    self.dateFormatter.dateFormat = "dd/MM/yyyy"
                    self.tripDateLabel.text = self.dateFormatter.string(from: self.selected_trip_date)
                    self.displayPlaceInfo(info_asset: self.selected_asset)
                }
                self.getAssetRouteModel.assetRoute(selected_asset: self.selected_asset, t_id: "")
            } else {
//                self.infoViewHeightConstraint.constant = 0
                self.all_assets_array = Utiles.assetItems_list
                if self.all_assets_array.count > 0 {
                    let lat_first:Double = Double(self.all_assets_array[0].a_lat!) ?? 0
                    let lng_first:Double = Double(self.all_assets_array[0].a_lon!) ?? 0
                    let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: lat_first, longitude: lng_first), zoom: DEFAULT_ZOOM)
                    self.mainMapView.camera = camera
                    showMarkers(all_assets: self.all_assets_array)
                } else {
                    self.first_open = true
                }
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.first_open = false
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
    
    func onGetAssetSuccess(assets: [AssetItem]) {
//        print(assets)
        self.all_assets_array = assets
        showMarkers(all_assets: assets)
        self.animateView()
        if self.first_open {
            self.first_open = false
            let lat_first:Double = Double(self.all_assets_array[0].a_lat!) ?? 0
            let lng_first:Double = Double(self.all_assets_array[0].a_lon!) ?? 0
            let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: lat_first, longitude: lng_first), zoom: DEFAULT_ZOOM)
            self.mainMapView.camera = camera
        }
        if assetSearchResultView.isHidden == false {
            self.arrangeAssetsArray(searchText: self.assetSearchText)
            self.assetListTableView.reloadData()
        }
    }
    
    func onGetAssetError(message: String) {
        print(message)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        self.arrangeAssetsArray(searchText: searchText)
        self.assetListTableView.reloadData()
        self.assetSearchResultView.isHidden = false
    }

    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        self.assetSearchText = searchText
        self.arrangeAssetsArray(searchText: searchText)
        self.assetListTableView.reloadData()
        print("--------\(searchText)")
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
        self.showMarkers(all_assets: self.all_assets_array)
        if self.assetSearchResultView.isHidden == false {
            self.arrangeAssetsArray(searchText: self.assetSearchText)
        }
    }
    
    @IBAction func mapSettingButtonAction(_ sender: Any) {
        if self.mapSettingView.isHidden {
            self.mapSettingView.isHidden = false
            self.toggleButtonView.backgroundColor = UIColor(red: 186/255, green: 242/255, blue: 92/255, alpha: 1)
        } else {
            self.mapSettingView.isHidden = true
            self.toggleButtonView.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func mapLabelSettingButtonAction(_ sender: UIButton) {
        if self.map_label_setting == 0 {
            self.map_label_setting = 1
            sender.setImage(UIImage(named: "label_black_on.png"), for: .normal)
        } else {
            self.map_label_setting = 0
            sender.setImage(UIImage(named: "label_white_off.png"), for: .normal)
        }
        self.showMarkers(all_assets: self.all_assets_array)
    }
    
    @IBAction func mapTrafficSettingButtonAction(_ sender: UIButton) {
        if self.map_traffic_setting == 0 {
            self.map_traffic_setting = 1
            self.mainMapView.isTrafficEnabled = true
            sender.setImage(UIImage(named: "traffic_black_on.png"), for: .normal)
        } else {
            self.map_traffic_setting = 0
            self.mainMapView.isTrafficEnabled = false
            sender.setImage(UIImage(named: "traffic_white_off.png"), for: .normal)
        }
    }
    
    @IBAction func mapSatelliteSettingButtonAction(_ sender: UIButton) {
        if self.map_satellite_setting == 0 {
            self.map_satellite_setting = 1
            self.mainMapView.mapType = .satellite
            sender.setImage(UIImage(named: "satellite_black_on.png"), for: .normal)
        } else {
            self.map_satellite_setting = 0
            self.mainMapView.mapType = .normal
            sender.setImage(UIImage(named: "satellite_white_off.png"), for: .normal)
        }
    }
    
    func showMarkers(all_assets: [AssetItem]){
        self.mainMapView.clear()
        for asset in all_assets { //all, alert, monitored, moving, stopped
            if self.filter_value == "all" {
                self.drawMarker(drawedAsset: asset)
            } else if self.filter_value == "alert" && asset.a_alarm == "1" {
                self.drawMarker(drawedAsset: asset)
            } else if self.filter_value == "monitored" && asset.a_mon == "1" {
                self.drawMarker(drawedAsset: asset)
            } else if self.filter_value == "moving" && asset.a_stat == "1" {
                self.drawMarker(drawedAsset: asset)
            } else if self.filter_value == "stopped" && asset.a_stat == "0" {
                self.drawMarker(drawedAsset: asset)
            }
        }
        if self.route_array.count > 0 {
            self.drawRoute(routes: self.route_array)
        }
    }
    
    func drawMarker(drawedAsset: AssetItem) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(Double(drawedAsset.a_lat!) ?? 0, Double(drawedAsset.a_lon!) ?? 0)
        var iconView: AssetMarkerView!
        var markerTitle = ""
        var markerImage = UIImage(named: "marker_stop.png")
        if self.map_label_setting == 1 {
            markerTitle = drawedAsset.a_name ?? ""
        }
        if drawedAsset.a_stat == "2" { // idle
            markerImage = UIImage(named: "marker_move_idle.png")
        } else if drawedAsset.a_stat == "1" { // moving
            if drawedAsset.a_alarm == "1" { // alert
                markerImage = UIImage(named: "marker_move_alert.png")
            } else {
                markerImage = UIImage(named: "marker_move.png")
            }
        } else if drawedAsset.a_stat == "0" { // stop
            if drawedAsset.a_alarm == "1" { // alert
                markerImage = UIImage(named: "marker_stop_alert.png")
            } else {
                markerImage = UIImage(named: "marker_stop.png")
            }
        }
        iconView = AssetMarkerView(image: markerImage!, title: markerTitle)
        iconView.frame.size.width = 170
        iconView.frame.size.height = 30
        marker.iconView = iconView
        marker.groundAnchor = CGPoint(x: 0.1, y: 0.5)
        if drawedAsset.a_stat == "1" {
            marker.rotation = Double(drawedAsset.a_dir!) ?? 0
        }
        marker.userData = drawedAsset
        marker.map = self.mainMapView
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let tapped_asset = marker.userData as! AssetItem
        self.selected_asset = tapped_asset
        self.asset_info_show = true
        self.detail_info_show = false
        self.selected_trip_date = Date()
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        self.tripDateLabel.text = self.dateFormatter.string(from: self.selected_trip_date)
        self.displayPlaceInfo(info_asset: self.selected_asset)
        self.getAssetRouteModel.assetRoute(selected_asset: self.selected_asset, t_id: "")
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.selected_asset = nil
        self.asset_info_show = false
        self.detail_info_show = false
        self.shown_category = "info"
        self.assetInfoDetailView.isHidden = true
        self.polyline.map = nil
        self.route_array = []
    }
    
    @IBAction func infoToggleButtonAction(_ sender: Any) {
        self.toggleDetailView()
    }
    
    func toggleDetailView() {
        if self.detail_info_show {
            self.detail_info_show = false
            if SVProgressHUD.isVisible() {
                SVProgressHUD.dismiss()
            }
        } else {
            self.detail_info_show = true
            self.displayDetailTable()
        }
        self.displayPlaceInfo(info_asset: self.selected_asset)
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        let textToShare = [(self.selected_asset.a_lat ?? "") + " " + (self.selected_asset.a_lon ?? ""), self.selected_asset.a_loc]
        let activityViewController = UIActivityViewController(activityItems: textToShare as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func directionButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Leave app?", message: "In order to proceed the action, you will leave the app. You can return to the app at anytime.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {[unowned self] action in
            
            let url = "http://maps.apple.com/maps?ll=\(self.selected_asset.a_lat ?? "0"),\(self.selected_asset.a_lon ?? "0")"
            UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {[unowned self] action in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func onAssetRouteSuccess(routes: [AssetRouteItem]) {
        self.route_array = routes
        self.drawRoute(routes: self.route_array)
    }
    
    func drawRoute(routes: [AssetRouteItem]) {
        let path = GMSMutablePath()
        for item in routes {
            if let lat = Double(item.a_lat!), let lng = Double(item.a_lon!) {
                path.add(CLLocationCoordinate2D(latitude: lat, longitude: lng))
            }
        }
        self.polyline.path = path
        polyline.map = self.mainMapView
    }
    
    func onAssetRouteError(message: String) {
        print(message)
    }
    
    
    func displayPlaceInfo(info_asset: AssetItem) {
        
        self.assetInfoNameLabel.text = info_asset.a_name
        self.assetInfoUserLabel.text = info_asset.a_user
        self.assetInfoAddrLabel.text = info_asset.a_loc
        self.assetInfoUpdateLabel.text = info_asset.a_timestamp
        if info_asset.a_stat == "1" { // moving state
            self.assetInfoStatusLabel.text = "MOVING" + " " + (info_asset.a_sp ?? "0") + " km/h"
        } else {
            if info_asset.a_alarm == "1" {
                self.assetInfoStatusLabel.text = "ALERT"
            } else if self.selected_asset.a_stat == "0" {
                self.assetInfoStatusLabel.text = "STOPPED"
            } else if self.selected_asset.a_stat == "2" {
                self.assetInfoStatusLabel.text = "IDLE"
            }
        }

        if self.detail_info_show {
//            SVProgressHUD.show()
            self.infoCategoryView.isHidden = false
            self.infoViewHeightConstraint.constant = CGFloat(self.safearea_height)
            self.infoDetailViewToggleButton.setImage(UIImage(named: "arrow_down.png"), for: .normal)
            
            self.getAssetDetailInfo(asset: info_asset)
            self.getAssetTripInfo(asset: info_asset, trip_date: self.selected_trip_date)
            self.getAssetMoreInfo(asset: info_asset)
            
            
        } else {
            self.infoViewHeightConstraint.constant = 145
            self.infoDetailViewToggleButton.setImage(UIImage(named: "arrow_up.png"), for: .normal)
            self.infoCategoryView.isHidden = true
        }
        self.infoTopView.roundCorners(corners: [.topLeft, .topRight], radius: 25)
        
        if self.asset_info_show {
            self.assetInfoDetailView.isHidden = false
        } else {
            self.assetInfoDetailView.isHidden = true
        }
        
        self.modalView.isHidden = true
    }
    
    func displayDetailTable() {
        if self.shown_category == "info" {
            self.infoButtonBottomLine.isHidden = false
            self.infoView.isHidden = false
            self.tripButtonBottomLine.isHidden = true
            self.tripsView.isHidden = true
            self.moreButtomBottomLine.isHidden = true
            self.moreView.isHidden = true
        } else if self.shown_category == "trips" {
            self.infoButtonBottomLine.isHidden = true
            self.infoView.isHidden = true
            self.tripButtonBottomLine.isHidden = false
            self.tripsView.isHidden = false
            self.moreButtomBottomLine.isHidden = true
            self.moreView.isHidden = true
        } else if self.shown_category == "more" {
            self.infoButtonBottomLine.isHidden = true
            self.infoView.isHidden = true
            self.tripButtonBottomLine.isHidden = true
            self.tripsView.isHidden = true
            self.moreButtomBottomLine.isHidden = false
            self.moreView.isHidden = false
        }
    }
    
    func getAssetDetailInfo(asset: AssetItem) {
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show()
        }
        self.getAssetDetailModel.assetDetail(selected_asset: asset)
    }
    
    func onAssetDetailSuccess(asset: AssetItem) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        self.info_array = asset.asset_cards_value ?? []
        self.infoCollectionView.reloadData()
    }
    
    func onAssetDetailError(message: String) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }
    
    
    func getAssetTripInfo(asset: AssetItem, trip_date: Date) {
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show()
        }
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        self.getAssetTripModel.assetTrips(selected_asset: asset, ts_date: self.dateFormatter.string(from: trip_date))
    }
    
    func onAssetTripSuccess(trips: [AssetTripItem]) {
        self.trip_array = trips
        self.tripTableView.reloadData()
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }
        
    func onAssetTripError(message: String) {
        print("fail")
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }
    
    func getAssetMoreInfo(asset: AssetItem) {
        self.more_array = asset.more_items ?? []
        self.moreTableView.reloadData()
    }
    
    @IBAction func infoButtonAction(_ sender: Any) {
        self.shown_category = "info"
        self.displayDetailTable()
    }
    
    @IBAction func tripButtonAction(_ sender: Any) {
        self.shown_category = "trips"
        self.displayDetailTable()
    }
    
    @IBAction func moreButtonAction(_ sender: Any) {
        self.shown_category = "more"
        self.displayDetailTable()
    }
    
    @IBAction func tripDateButtonAction(_ sender: Any) {
        self.tripDatePicker.date = self.selected_trip_date
        self.modalView.isHidden = false
    }
    
    @IBAction func tripDatePickOkButtonAction(_ sender: Any) {
        self.selected_trip_date = self.tripDatePicker.date
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        self.tripDateLabel.text = self.dateFormatter.string(from: self.selected_trip_date)
        self.getAssetTripInfo(asset: self.selected_asset, trip_date: self.selected_trip_date)
        self.modalView.isHidden = true
    }
    
    @IBAction func tripDatePickCancelButtonAction(_ sender: Any) {
        self.modalView.isHidden = true
    }
    
    @IBAction func tripDatePrevButtonAction(_ sender: Any) {
        self.selected_trip_date = Calendar.current.date(byAdding: .day, value: -1, to: self.selected_trip_date)!
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        self.tripDateLabel.text = self.dateFormatter.string(from: self.selected_trip_date)
        self.getAssetTripInfo(asset: self.selected_asset, trip_date: self.selected_trip_date)
    }
    
    @IBAction func tripDateNextButtonAction(_ sender: Any) {
        self.selected_trip_date = Calendar.current.date(byAdding: .day, value: 1, to: self.selected_trip_date)!
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        self.tripDateLabel.text = self.dateFormatter.string(from: self.selected_trip_date)
        self.getAssetTripInfo(asset: self.selected_asset, trip_date: self.selected_trip_date)
    }
    /*    collectionview, table view delegate functions    */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.info_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.info_array[indexPath.row]
        let card_type = Utiles.getCardType(assetCardValue: item)
        if card_type.a_card_type == "A" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssetCardTypeACollectionViewCell", for: indexPath) as! AssetCardTypeACollectionViewCell
            cell.titleLabel.text = card_type.a_card_title
            cell.item1Label.text = item.a_card_item1
            cell.item1Label.textColor = Utiles.colorWithHexString(hex: item.a_card_item1_color ?? "")
            cell.noteLabel.text = item.a_card_note
            return cell
        } else if card_type.a_card_type == "B" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssetCardTypeBCollectionViewCell", for: indexPath) as! AssetCardTypeBCollectionViewCell
            cell.titleLabel.text = card_type.a_card_title
            cell.item1Label.text = item.a_card_item1
            cell.item1Label.textColor = Utiles.colorWithHexString(hex: item.a_card_item1_color ?? "")
            cell.item1CaptionLabel.text = card_type.a_card_item1_caption
            cell.item2Label.text = item.a_card_item2
            cell.item2Label.textColor = Utiles.colorWithHexString(hex: item.a_card_item2_color ?? "")
            cell.item2CaptionLabel.text = card_type.a_card_item2_caption
            cell.noteLabel.text = item.a_card_note
            return cell
        } else if card_type.a_card_type == "C" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssetCardTypeCCollectionViewCell", for: indexPath) as! AssetCardTypeCCollectionViewCell
            cell.titleLabel.text = card_type.a_card_title
            cell.item1Label.text = item.a_card_item1
            cell.item1Label.textColor = Utiles.colorWithHexString(hex: item.a_card_item1_color ?? "")
            cell.item1CaptionLabel.text = card_type.a_card_item1_caption
            cell.noteLabel.text = item.a_card_note
            if let percent_str = item.a_card_item2 {
                if percent_str == "" {
                    cell.circleProgressbar.setProgress(to: 0, withAnimation: false)
                } else {
                    let number_str = percent_str.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                    if let percent = Float(number_str) {
                        cell.circleProgressbar.setProgress(to: Double(percent / 100), withAnimation: false)
                    } else {
                        cell.circleProgressbar.setProgress(to: 0, withAnimation: false)
                    }
                }
            } else {
                cell.circleProgressbar.setProgress(to: 0, withAnimation: false)
            }
            
            return cell
        } else { // card_type == "E" this is equal to case "A"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCollectionViewCell", for: indexPath) as! AssetCardTypeACollectionViewCell
            cell.titleLabel.text = card_type.a_card_title
            cell.item1Label.text = item.a_card_item1
            cell.item1Label.textColor = Utiles.colorWithHexString(hex: item.a_card_item1_color ?? "")
            cell.noteLabel.text = item.a_card_note
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 5) / 2, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0.0, right: 0.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tripTableView {
            return self.trip_array.count
        } else if tableView == self.moreTableView {
            return self.more_array.count
        } else if tableView == self.assetListTableView {
            return self.listAssetItems_array[section].assetItems?.count ?? 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tripTableView {
            if indexPath.row == self.trip_array.count - 1 {
                return 260
            } else {
                return 240
            }
        } else if tableView == self.moreTableView {
            return 100
        } else if tableView == self.assetListTableView {
            return 50
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.assetListTableView {
            return self.listAssetItems_array.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.assetListTableView {
            let headerView = Bundle.main.loadNibNamed("AssetListTableViewCellHeader", owner: self, options: nil)?.first as! AssetListTableViewCellHeader
            headerView.statusLabel.text = self.listAssetItems_array[section].a_status
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.assetListTableView {
            return 25
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tripTableView {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mapRouteVC = storyboard.instantiateViewController(withIdentifier: "MapRouteViewController") as! MapRouteViewController
            mapRouteVC.trip_array = self.trip_array
            mapRouteVC.selected_index = indexPath.row
            self.dateFormatter.dateFormat = "dd/MM/yyyy"
            mapRouteVC.selected_date = self.dateFormatter.string(from: self.selected_trip_date)
            mapRouteVC.selected_asset = self.selected_asset
            self.navigationController?.pushViewController(mapRouteVC, animated: true)
        } else if tableView == self.assetListTableView {
            let tapped_asset = self.listAssetItems_array[indexPath.section].assetItems![indexPath.row]
            self.selected_asset = tapped_asset
            self.asset_info_show = true
            self.detail_info_show = false
            self.selected_trip_date = Date()
            self.dateFormatter.dateFormat = "dd/MM/yyyy"
            self.tripDateLabel.text = self.dateFormatter.string(from: self.selected_trip_date)
            self.displayPlaceInfo(info_asset: self.selected_asset)
            self.getAssetRouteModel.assetRoute(selected_asset: self.selected_asset, t_id: "")
            
            self.assetSearchText = ""
            self.searchTextField.text = ""
            self.assetSearchResultView.isHidden = true
            self.view.endEditing(true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tripTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TripTableViewCell") as! TripTableViewCell
            self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let startdate = self.dateFormatter.date(from: self.trip_array[indexPath.row].t_start_time!) {
                self.dateFormatter.dateFormat = "hh:mm"
                cell.startTimeLabel.text = self.dateFormatter.string(from: startdate)
                self.dateFormatter.dateFormat = "a"
                self.dateFormatter.amSymbol = "AM"
                self.dateFormatter.pmSymbol = "PM"
                cell.startAALabel.text = self.dateFormatter.string(from: startdate)
            } else {
                cell.startTimeLabel.text = "00:00"
                cell.startAALabel.text = "AM"
            }
            self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let stopdate = self.dateFormatter.date(from: self.trip_array[indexPath.row].t_stop_time!) {
                self.dateFormatter.dateFormat = "hh:mm"
                cell.stopTimeLabel.text = self.dateFormatter.string(from: stopdate)
                self.dateFormatter.dateFormat = "a"
                self.dateFormatter.amSymbol = "AM"
                self.dateFormatter.pmSymbol = "PM"
                cell.stopAALabel.text = self.dateFormatter.string(from: stopdate)
            } else {
                cell.stopTimeLabel.text = "00:00"
                cell.stopAALabel.text = "AM"
            }
            if let tripDist = self.trip_array[indexPath.row].t_dist {
                cell.distanceLabel.text = tripDist + "km"
            } else {
                cell.distanceLabel.text = "0km"
            }
            cell.durationLabel.text = Utiles.timeConverter(time_string: self.trip_array[indexPath.row].t_duration!)
            if let tripStartLoc = self.trip_array[indexPath.row].t_start_loc {
                cell.startLocLabel.text = tripStartLoc
            } else {
                cell.startLocLabel.text = ""
            }
            if let tripStopLoc = self.trip_array[indexPath.row].t_stop_loc {
                cell.startLocLabel.text = tripStopLoc
            } else {
                cell.startLocLabel.text = ""
            }
            if let tripDriver = self.trip_array[indexPath.row].t_driver {
                cell.driveLabel.text = tripDriver
            } else {
                cell.driveLabel.text = ""
            }
            if indexPath.row == self.trip_array.count - 1 {
                cell.prevStartImageView.isHidden = false
                cell.idleTimeLabel.isHidden = true
            } else {
                cell.prevStartImageView.isHidden = true
                cell.idleTimeLabel.isHidden = false
                self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let current_startdate = self.dateFormatter.date(from: self.trip_array[indexPath.row].t_start_time!), let next_stopdate = self.dateFormatter.date(from: self.trip_array[indexPath.row + 1].t_stop_time!) {
                    let diff_sec = Int(current_startdate.timeIntervalSince(next_stopdate))
                    if diff_sec < 0 {
                        cell.idleTimeLabel.text = "Stopped -" + Utiles.timeConverter(time_string: String(diff_sec * -1))
                    } else {
                        cell.idleTimeLabel.text = "Stopped " + Utiles.timeConverter(time_string: String(diff_sec))
                    }
                } else {
                    cell.idleTimeLabel.text = "Stopped " + "0m"
                }
            }
            cell.counterLabel.text = String(self.trip_array.count - indexPath.row)
            return cell
        } else if tableView == self.moreTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoreTableViewCell") as! MoreTableViewCell
            cell.titleLabel.text = self.more_array[indexPath.row].title
            cell.infoLabel.text = self.more_array[indexPath.row].info
            cell.bodyLabel.text = self.more_array[indexPath.row].body
            cell.seqLabel.text = self.more_array[indexPath.row].seq
            return cell
        } else { // if tableView == self.assetListTablveView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AssetListTableViewCell") as! AssetListTableViewCell
            cell.selectionStyle = .none
            let asset = self.listAssetItems_array[indexPath.section].assetItems![indexPath.row]
            cell.assetNameLabel.text = asset.a_name
            cell.assetAddressLabel.text = asset.a_loc
            
            cell.alertView.isHidden = true
            
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
                let tapped_asset = self.listAssetItems_array[indexPath.section].assetItems![indexPath.row]
                self.selected_asset = tapped_asset
                self.asset_info_show = true
                self.detail_info_show = false
                self.selected_trip_date = Date()
                self.dateFormatter.dateFormat = "dd/MM/yyyy"
                self.tripDateLabel.text = self.dateFormatter.string(from: self.selected_trip_date)
                self.displayPlaceInfo(info_asset: self.selected_asset)
                self.getAssetRouteModel.assetRoute(selected_asset: self.selected_asset, t_id: "")
                
                self.assetSearchText = ""
                self.searchTextField.text = ""
                self.assetSearchResultView.isHidden = true
                self.view.endEditing(true)
            }
            cell.gotoMapList = {
                let tapped_asset = self.listAssetItems_array[indexPath.section].assetItems![indexPath.row]
                self.selected_asset = tapped_asset
                self.asset_info_show = true
                self.detail_info_show = false
                self.selected_trip_date = Date()
                self.dateFormatter.dateFormat = "dd/MM/yyyy"
                self.tripDateLabel.text = self.dateFormatter.string(from: self.selected_trip_date)
                self.displayPlaceInfo(info_asset: self.selected_asset)
                self.getAssetRouteModel.assetRoute(selected_asset: self.selected_asset, t_id: "")
                
                self.assetSearchText = ""
                self.searchTextField.text = ""
                self.assetSearchResultView.isHidden = true
                self.view.endEditing(true)
            }
            cell.eraseAlert = {
                let tapped_asset = self.listAssetItems_array[indexPath.section].assetItems![indexPath.row]
                self.selected_asset = tapped_asset
                self.asset_info_show = true
                self.detail_info_show = false
                self.selected_trip_date = Date()
                self.dateFormatter.dateFormat = "dd/MM/yyyy"
                self.tripDateLabel.text = self.dateFormatter.string(from: self.selected_trip_date)
                self.displayPlaceInfo(info_asset: self.selected_asset)
                self.getAssetRouteModel.assetRoute(selected_asset: self.selected_asset, t_id: "")
                
                self.assetSearchText = ""
                self.searchTextField.text = ""
                self.assetSearchResultView.isHidden = true
                self.view.endEditing(true)
            }
             
            return cell
        }
    }
    
    func arrangeAssetsArray(searchText: String) {
        self.monitored_assets_array.removeAll()
        self.alarm_assets_array.removeAll()
        self.stopped_assets_array.removeAll()
        self.moving_assets_array.removeAll()
        self.idle_assets_array.removeAll()
        
        for item in all_assets_array {
            if item.a_alarm == "1" {
                if self.filter_value == "all" || self.filter_value == "alert" {
                    if searchText == "" {
                        self.alarm_assets_array.append(item)
                    } else {
                        if item.a_name?.lowercased().range(of: searchText.lowercased()) != nil ||
                            item.a_loc?.lowercased().range(of: searchText.lowercased()) != nil  {
                            self.alarm_assets_array.append(item)
                        }
                    }
                }
            } else if item.a_mon == "1" {
                if self.filter_value == "all" || self.filter_value == "monitored" {
                    if searchText == "" {
                        self.monitored_assets_array.append(item)
                    } else {
                        
                        if item.a_name?.lowercased().range(of: searchText.lowercased()) != nil ||
                            item.a_loc?.lowercased().range(of: searchText.lowercased()) != nil {
                            self.monitored_assets_array.append(item)
                        }
                    }
                }
            } else if item.a_stat == "1" {
                if self.filter_value == "all" || self.filter_value == "moving" {
                    if searchText == "" {
                        self.moving_assets_array.append(item)
                    } else {
                        if item.a_name?.lowercased().range(of: searchText.lowercased()) != nil ||
                            item.a_loc?.lowercased().range(of: searchText.lowercased()) != nil {
                            self.moving_assets_array.append(item)
                        }
                    }
                }
            } else if item.a_stat == "0" {
                if self.filter_value == "all" || self.filter_value == "stopped" {
                    if searchText == "" {
                        self.stopped_assets_array.append(item)
                    } else {
                        if item.a_name?.lowercased().range(of: searchText.lowercased()) != nil ||
                            item.a_loc?.lowercased().range(of: searchText.lowercased()) != nil {
                            self.stopped_assets_array.append(item)
                        }
                    }
                }
            }
//            else if item.a_stat == "2" {
//                if self.filter_value == "all" || self.filter_value == "idle" {
//                    if searchText == "" {
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
}

