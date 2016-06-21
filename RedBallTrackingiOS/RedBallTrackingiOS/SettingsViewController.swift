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
        
        // Make sure the min bar is never high than the max bar
        switch sender {
        case hMin:  if hMin.value > hMax.value { hMax.setValue(hMin.value+1, animated: false) }
        case hMax:  if hMin.value > hMax.value { hMin.setValue(hMax.value-1, animated: false) }
        case sMin:  if sMin.value > sMax.value { sMax.setValue(sMin.value+1, animated: false) }
        case sMax:  if sMin.value > sMax.value { sMin.setValue(sMax.value-1, animated: false) }
        case vMin:  if vMin.value > vMax.value { vMax.setValue(vMin.value+1, animated: false) }
        case vMax:  if vMin.value > vMax.value { vMin.setValue(vMax.value-1, animated: false) }
        default: break
        }
    }
    
    
    @IBAction func pressedChangeServerAddressButton(sender: UIButton) {
        let alertController = UIAlertController(title: "Server Address", message: "Enter the server's IP or local network address", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.text = CommHanlder.sharedInstance.serverAddress
        }
        
        let updateAction = UIAlertAction(title: "Save", style: .Default) { (action) in
            if let newAddress = alertController.textFields![0].text {
                CommHanlder.sharedInstance.serverAddress = newAddress
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(updateAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}
