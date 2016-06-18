//
//  SettingsViewController.swift
//  RedBallTrackingiOS
//
//  Created by Erik Hornberger on 2016/06/18.
//  Copyright © 2016年 EExT. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let ocv = OpenCVWrapper.sharedInstance()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        ocv.showProcessedImage(true)
        
        hMin.setValue(Float(ocv.hMin), animated: false)
        hMax.setValue(Float(ocv.hMax), animated: false)
        
        sMin.setValue(Float(ocv.sMin), animated: false)
        sMax.setValue(Float(ocv.sMax), animated: false)
        
        vMin.setValue(Float(ocv.vMin), animated: false)
        vMax.setValue(Float(ocv.vMax), animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        ocv.showProcessedImage(false)
    }

    // References to the sliders on the settings page
    @IBOutlet weak var hMin: UISlider!
    @IBOutlet weak var hMax: UISlider!
    @IBOutlet weak var sMin: UISlider!
    @IBOutlet weak var sMax: UISlider!
    @IBOutlet weak var vMin: UISlider!
    @IBOutlet weak var vMax: UISlider!
    
    // Update the variables used for filtering by OpenCV
    @IBAction func sliderChanged(sender:UISlider) {
        let value = NSInteger(sender.value)
        
        switch sender {
        case hMin:  ocv.hMin = value
        case hMax:  ocv.hMax = value
        case sMin:  ocv.sMin = value
        case sMax:  ocv.sMax = value
        case vMin:  ocv.vMin = value
        case vMax:  ocv.vMax = value
        default: break
        }
    }
}
