//
//  MotionMarkerView.swift
//  NGTMobile
//
//  Created by Water Flower on 12/3/20.
//

import UIKit

class MotionMarkerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var spLabel: UILabel!
    @IBOutlet var spView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInitialization()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInitialization()
    }
    
    func commonInitialization() {
        let view = Bundle.main.loadNibNamed("MotionMarkerView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func setRound() {
        self.spView.layer.cornerRadius = 2
        self.spView.layer.borderWidth = 0.5
        self.spView.layer.borderColor = UIColor.gray.cgColor
        self.iconImageView.layer.cornerRadius = 15 / 2
    }
    
    func setSpeed(speed: String) {
        self.spLabel.text = speed
    }

}
