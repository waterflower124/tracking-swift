//
//  NotificationViewController.swift
//  NGTMobile
//
//  Created by Water Flower on 11/19/20.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet var filterButton: UIButton!
    @IBOutlet var searchUIView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.filterButton.layer.cornerRadius = 5
        self.searchUIView.layer.cornerRadius = 5
        
    }

}
