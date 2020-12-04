//
//  MapRouteViewController.swift
//  NGTMobile
//
//  Created by Water Flower on 12/1/20.
//

import UIKit
import SVProgressHUD
import Alamofire
import ObjectMapper
import GoogleMaps
import MapKit

class MapRouteViewController: UIViewController, AssetRouteProtocol {

    @IBOutlet var routeMapView: GMSMapView!
    @IBOutlet var tripPrevView: UIView!
    @IBOutlet var tripNextView: UIView!
    @IBOutlet var dateView: UIView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var outerView: UIView!
    @IBOutlet var innerView: UIView!
    @IBOutlet var tripDateLabel: UILabel!
    @IBOutlet var stopTimeLabel: UILabel!
    @IBOutlet var stopAALabel: UILabel!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var startAALabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var stopLocLabel: UILabel!
    @IBOutlet var startLocLabel: UILabel!
    @IBOutlet var driverLabel: UILabel!
    @IBOutlet var counterView: UIView!
    @IBOutlet var counterLabel: UILabel!
    
    var trip_array: [AssetTripItem] = []
    var route_array: [AssetRouteItem] = []
    var selected_asset: AssetItem!
    var selected_index: Int = 0
    var selected_date: String = ""
    var play_status = false // if true the playing, if false then pause
    
    var getAssetRouteModel: AssetRouteModel = AssetRouteModel()
    
    var polyline: GMSPolyline = GMSPolyline()
    
    var motionIndex:Int = 0
    var motionTimer: Timer?
    var markerMotion = GMSMarker()
    var markerMotionIconView = MotionMarkerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tripDateLabel.text = self.selected_date
        self.displayTripInfo()
        
        getAssetRouteModel.assetRouteProtocol = self
        
        SVProgressHUD.show()
        getAssetRouteModel.assetRoute(selected_asset: self.selected_asset, t_id: self.trip_array[self.selected_index].t_id!)
        
        self.polyline.strokeColor = UIColor(red: 20/255, green: 114/255, blue: 255/255, alpha: 1)
        self.polyline.strokeWidth = 5
        
        self.markerMotionIconView.setRound()
        self.markerMotionIconView.frame.size.width = 140
        self.markerMotionIconView.frame.size.height = 25
        self.markerMotion.iconView = markerMotionIconView
        self.markerMotion.groundAnchor = CGPoint(x: 0.94, y: 0.5)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        self.outerView.layer.cornerRadius = 5
        self.outerView.layer.borderWidth = 1
        self.outerView.layer.borderColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1).cgColor
        self.innerView.layer.cornerRadius = 5
        self.tripPrevView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 5)
        self.tripNextView.roundCorners(corners: [.topRight, .bottomRight], radius: 5)
        self.dateView.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        self.playButton.layer.cornerRadius = 30 / 2
        self.counterView.layer.cornerRadius = 30 / 2
        self.counterView.layer.borderWidth = 0.5
        self.counterView.layer.borderColor = UIColor.black.cgColor
    }
    
    func displayTripInfo() {
        self.counterLabel.text = String(self.trip_array.count - self.selected_index)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let startdate = dateFormatter.date(from: self.trip_array[self.selected_index].t_start_time!) {
            dateFormatter.dateFormat = "hh:mm"
            self.startTimeLabel.text = dateFormatter.string(from: startdate)
            dateFormatter.dateFormat = "a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            self.startAALabel.text = dateFormatter.string(from: startdate)
        } else {
            self.startTimeLabel.text = "00:00"
            self.startAALabel.text = "AM"
        }
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let stopdate = dateFormatter.date(from: self.trip_array[self.selected_index].t_stop_time!) {
            dateFormatter.dateFormat = "hh:mm"
            self.stopTimeLabel.text = dateFormatter.string(from: stopdate)
            dateFormatter.dateFormat = "a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            self.stopAALabel.text = dateFormatter.string(from: stopdate)
        } else {
            self.stopTimeLabel.text = "00:00"
            self.stopAALabel.text = "AM"
        }
        if let tripDist = self.trip_array[self.selected_index].t_dist {
            self.distanceLabel.text = tripDist + "km"
        } else {
            self.distanceLabel.text = "0km"
        }
        self.durationLabel.text = Utiles.timeConverter(time_string: self.trip_array[self.selected_index].t_duration!)
        if let tripStartLoc = self.trip_array[self.selected_index].t_start_loc {
            self.startLocLabel.text = tripStartLoc
        } else {
            self.startLocLabel.text = ""
        }
        if let tripStopLoc = self.trip_array[self.selected_index].t_stop_loc {
            self.startLocLabel.text = tripStopLoc
        } else {
            self.startLocLabel.text = ""
        }
        if let tripDriver = self.trip_array[self.selected_index].t_driver {
            self.driverLabel.text = tripDriver
        } else {
            self.driverLabel.text = ""
        }
    }

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func prevTripButtonAction(_ sender: Any) {
        if self.selected_index > 0 {
            if ((motionTimer?.isValid) != nil) {
                self.motionTimer?.invalidate()
            }
            self.playButton.setImage(UIImage(named: "route_play.png"), for: .normal)
            self.play_status = false
            self.selected_index -= 1
            self.displayTripInfo()
            
            SVProgressHUD.show()
            getAssetRouteModel.assetRoute(selected_asset: self.selected_asset, t_id: self.trip_array[self.selected_index].t_id!)
        }
    }
    
    @IBAction func nextTripButtonAction(_ sender: Any) {
        if self.selected_index < self.trip_array.count - 1 {
            if ((motionTimer?.isValid) != nil) {
                self.motionTimer?.invalidate()
            }
            self.playButton.setImage(UIImage(named: "route_play.png"), for: .normal)
            self.play_status = false
            self.selected_index += 1
            self.displayTripInfo()
            
            SVProgressHUD.show()
            getAssetRouteModel.assetRoute(selected_asset: self.selected_asset, t_id: self.trip_array[self.selected_index].t_id!)
        }
    }
    
    @IBAction func playButtonAction(_ sender: Any) {
        if self.route_array.count > 0 {
            self.play_status = !self.play_status
            if play_status {
                self.playButton.setImage(UIImage(named: "route_pause.png"), for: .normal)
                self.playMotion()
            } else {
                self.playButton.setImage(UIImage(named: "route_play.png"), for: .normal)
                if (self.motionTimer?.isValid) != nil {
                    self.motionTimer?.invalidate()
                }
            }
        }
    }
    
    func convert_date(strDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let dateDate = dateFormatter.date(from: strDate) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: dateDate)
        } else {
            return "00:00"
        }
    }
    
    func playMotion() {
        if self.motionIndex <= 0 {
            self.motionIndex = self.route_array.count - 1
        }
        self.markerMotion.map = self.routeMapView
        self.motionTimer =  Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { [self] (timer) in
            if self.motionIndex < 0 {
                self.motionTimer?.invalidate()
                self.play_status = false
                self.playButton.setImage(UIImage(named: "route_play.png"), for: .normal)
                return;
            }
           
            self.markerMotion.position = CLLocationCoordinate2DMake(Double(self.route_array[self.motionIndex].a_lat!) ?? 0, Double(self.route_array[self.motionIndex].a_lon!) ?? 0)
            let timestamp = self.convert_date(strDate: self.route_array[self.motionIndex].a_timestamp ?? "")
            let speed = (self.route_array[self.motionIndex].a_sp) ?? "0"
            self.markerMotionIconView.setSpeed(speed: timestamp + " - " + speed + " kmph")
            
            self.motionIndex -= 1
        }
    }
    
    func drawRoute(routes: [AssetRouteItem]) {
        self.routeMapView.clear()
        let path = GMSMutablePath()
        for item in routes {
            if let lat = Double(item.a_lat!), let lng = Double(item.a_lon!) {
                path.add(CLLocationCoordinate2D(latitude: lat, longitude: lng))
            }
        }
        self.polyline.path = path
        polyline.map = self.routeMapView
    }
    
    func onAssetRouteSuccess(routes: [AssetRouteItem]) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        self.route_array = routes
        // animate map to route
        var bounds = GMSCoordinateBounds()
        var location2d: CLLocationCoordinate2D!
        for route in self.route_array {
            if let lat = Double(route.a_lat!), let lng = Double(route.a_lon!) {
                location2d = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            }
            bounds = bounds.includingCoordinate(location2d)
        }
            
        let update = GMSCameraUpdate.fit(bounds, withPadding: 20)
        routeMapView.animate(with: update)
        
        self.drawRoute(routes: self.route_array)
        self.motionIndex = self.route_array.count - 1
        
        if self.route_array.count > 0 {
            
            let startRoute = self.route_array[self.route_array.count - 1]
            let startMarker = GMSMarker()
            startMarker.position = CLLocationCoordinate2DMake(Double(startRoute.a_lat!) ?? 0, Double(startRoute.a_lon!) ?? 0)
            let startIconView = UIImageView(image: UIImage(named: "trip_start_loc.png")!)
//            startIconView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            startIconView.frame.size.width = 30
            startIconView.frame.size.height = 30
            startMarker.iconView = startIconView
            startMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            startMarker.map = self.routeMapView
            
            let stopRoute = self.route_array[0]
            let stopMarker = GMSMarker()
            stopMarker.position = CLLocationCoordinate2DMake(Double(stopRoute.a_lat!) ?? 0, Double(stopRoute.a_lon!) ?? 0)
            let stopIconView = UIImageView(image: UIImage(named: "trip_stop_loc.png")!)
            stopIconView.frame.size.width = 30
            stopIconView.frame.size.height = 30
            stopMarker.iconView = stopIconView
            stopMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            stopMarker.map = self.routeMapView
        }
    }
    
    func onAssetRouteError(message: String) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        print(message)
    }
    
    
    

}
