//
//  EnableMonitoringViewController.swift
//  NGTMobile
//
//  Created by Water Flower on 11/24/20.
//

import UIKit
import SVProgressHUD
import DropDown
import Alamofire
import ObjectMapper

class EnableMonitoringViewController: UIViewController, MonitorAssetProtocol {

    
    @IBOutlet var periodView: UIView!
    @IBOutlet var periodLabel: UILabel!
    @IBOutlet var datetimeView: UIView!
    @IBOutlet var datetimeLabel: UILabel!
    @IBOutlet var datetimeSelectionView: UIView!
    
    @IBOutlet var datetimeStartButton: UIButton!
    @IBOutlet var datetimeStopButton: UIButton!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var timePicker: UIDatePicker!
    
    var selected_asset: AssetItem!
    var selected_period = 15 // minute of selected period
    
    var dateFormatter: DateFormatter!
    
    var startDate_date = Date()
    var startTime_date = Date()
    var stopDate_date = Date()
    var stopTime_date = Date()
    
    var datetime_selection = 0 // 0: start time, 1: stop time
    
    var monitorAssetModel = MonitorAssetModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        periodView.layer.borderWidth = 1
        periodView.layer.borderColor = UIColor.gray.cgColor
        datetimeView.layer.borderWidth = 1
        datetimeView.layer.borderColor = UIColor.gray.cgColor
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM HH:mm"
        
        let startDateTime_date = Date()
        let startDateTime_str = dateFormatter.string(from: startDateTime_date)
        let stopDateTime_date = Calendar.current.date(byAdding: .hour, value: 24, to: startDateTime_date)!
        let stopDateTime_str = dateFormatter.string(from: stopDateTime_date)
        self.datetimeLabel.text = startDateTime_str + " to " + stopDateTime_str
        
        self.startDate_date = Date()
        self.startTime_date = Date()
        self.stopDate_date = Calendar.current.date(byAdding: .hour, value: 24, to: self.startDate_date)!
        self.stopTime_date = Calendar.current.date(byAdding: .hour, value: 24, to: self.startDate_date)!
        
        self.datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        self.timePicker.addTarget(self, action: #selector(timePickerChanged), for: .valueChanged)
        
        monitorAssetModel.monitorAssetProtocol = self
    }
    
    @objc func datePickerChanged() {
        if self.datetime_selection == 0 {
            self.startDate_date = self.datePicker.date
        } else {
            self.stopDate_date = self.datePicker.date
        }
    }
    
    @objc func timePickerChanged() {
        if self.datetime_selection == 0 {
            self.startTime_date = self.timePicker.date
        } else {
            self.stopTime_date = self.timePicker.date
        }
    }
    
    @IBAction func periodDropDownButtonAction(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = ["15 m", "30 m", "1 h", "1.5 h"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.periodLabel.text = item
            self.selected_period = 15 * (index + 1)
            
        }
        dropDown.backgroundColor = UIColor.white
        dropDown.textFont = UIFont(name:"Roboto-Regular", size: 14)!
        dropDown.show()
    }
    
    @IBAction func dateDropDownButtonAction(_ sender: Any) {
        self.datetimeStartButton.backgroundColor = UIColor.lightGray
        self.datetimeStopButton.backgroundColor = UIColor.clear
        self.datePicker.date = self.startDate_date
        self.timePicker.date = self.startTime_date
        self.datetime_selection = 0
        self.datetimeSelectionView.isHidden = false
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        SVProgressHUD.show()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate_str = dateFormatter.string(from: self.startDate_date)
        let stopDate_str = dateFormatter.string(from: self.stopDate_date)
        dateFormatter.dateFormat = "HH:mm"
        let startTime_str = dateFormatter.string(from: self.startTime_date)
        let stopTime_str = dateFormatter.string(from: self.stopTime_date)
        
        self.monitorAssetModel.toggleMonitorAsset(toggled_asset: self.selected_asset, mon_interval: self.selected_period, mon_starttime: startDate_str + " " + startTime_str, mon_stoptime: stopDate_str + " " + stopTime_str)
    }
    
    @IBAction func datetimeStartButtonAction(_ sender: Any) {
        self.datetimeStartButton.backgroundColor = UIColor.lightGray
        self.datetimeStopButton.backgroundColor = UIColor.clear
        self.datePicker.date = self.startDate_date
        self.timePicker.date = self.startTime_date
        self.datetime_selection = 0
    }
    
    @IBAction func datetimeStopButtonAction(_ sender: Any) {
        self.datetimeStartButton.backgroundColor = UIColor.clear
        self.datetimeStopButton.backgroundColor = UIColor.lightGray
        self.datePicker.date = self.stopDate_date
        self.timePicker.date = self.stopTime_date
        self.datetime_selection = 1
    }
    
    @IBAction func datetimeCancelButtonAction(_ sender: Any) {
        self.datetimeSelectionView.isHidden = true
    }
    
    @IBAction func datetimeDoneButtonAction(_ sender: Any) {
        dateFormatter.dateFormat = "dd MMM"
        let startDate_str = dateFormatter.string(from: self.startDate_date)
        let stopDate_str = dateFormatter.string(from: self.stopDate_date)
        dateFormatter.dateFormat = "HH:mm"
        let startTime_str = dateFormatter.string(from: self.startTime_date)
        let stopTime_str = dateFormatter.string(from: self.stopTime_date)
        
        self.datetimeLabel.text = startDate_str + " " + startTime_str + " to " + stopDate_str + " " + stopTime_str
        self.datetimeSelectionView.isHidden = true
    }
    
    func onMonitorAssetSuccess(message: String) {
        SVProgressHUD.dismiss()
        self.navigationController?.popViewController(animated: true)
    }
    
    func onMonitorAssetError(message: String) {
        SVProgressHUD.dismiss()
        if message == "auth_error" {
            
        } else if message == "network_error" {
            
        }
    }
    
}
