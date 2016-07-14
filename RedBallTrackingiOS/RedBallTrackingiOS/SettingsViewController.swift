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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ocv?.showProcessedImage(true)
        
        // Setup the sliders
        segmentedControlChanged(segmentedControl)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ocv?.showProcessedImage(false)
    }
    
    // The segmented control at the top of the screen
    @IBOutlet weak var segmentedControl:UISegmentedControl!

    // References to the sliders on the settings page
    @IBOutlet weak var hMin: UISlider!
    @IBOutlet weak var hMax: UISlider!
    @IBOutlet weak var sMin: UISlider!
    @IBOutlet weak var sMax: UISlider!
    @IBOutlet weak var vMin: UISlider!
    @IBOutlet weak var vMax: UISlider!
    
    // When the segmented controller changes, update the values of the sliders
    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: // RED
            hMin.setValue(Float(ocv.hMin1), animated: true)
            hMax.setValue(Float(ocv.hMax1), animated: true)
            
            sMin.setValue(Float(ocv.sMin1), animated: true)
            sMax.setValue(Float(ocv.sMax1), animated: true)
            
            vMin.setValue(Float(ocv.vMin1), animated: true)
            vMax.setValue(Float(ocv.vMax1), animated: true)
        
        case 1: // BLUE
            hMin.setValue(Float(ocv.hMin2), animated: true)
            hMax.setValue(Float(ocv.hMax2), animated: true)
            
            sMin.setValue(Float(ocv.sMin2), animated: true)
            sMax.setValue(Float(ocv.sMax2), animated: true)
            
            vMin.setValue(Float(ocv.vMin2), animated: true)
            vMax.setValue(Float(ocv.vMax2), animated: true)
            
        case 2: // YELLOW
            hMin.setValue(Float(ocv.hMin3), animated: true)
            hMax.setValue(Float(ocv.hMax3), animated: true)
            
            sMin.setValue(Float(ocv.sMin3), animated: true)
            sMax.setValue(Float(ocv.sMax3), animated: true)
            
            vMin.setValue(Float(ocv.vMin3), animated: true)
            vMax.setValue(Float(ocv.vMax3), animated: true)
        default:
            break
        }
    }
    
    // Update the variables used for filtering by OpenCV
    @IBAction func sliderChanged(_ sender:UISlider) {
        let value = NSInteger(sender.value)
        
        switch segmentedControl.selectedSegmentIndex {
        case 0: // RED
            switch sender {
            case hMin:  ocv.hMin1 = value
            case hMax:  ocv.hMax1 = value
            case sMin:  ocv.sMin1 = value
            case sMax:  ocv.sMax1 = value
            case vMin:  ocv.vMin1 = value
            case vMax:  ocv.vMax1 = value
            default: break
            }
            
        case 1:
            switch sender {
            case hMin:  ocv.hMin2 = value
            case hMax:  ocv.hMax2 = value
            case sMin:  ocv.sMin2 = value
            case sMax:  ocv.sMax2 = value
            case vMin:  ocv.vMin2 = value
            case vMax:  ocv.vMax2 = value
            default: break
            }
            
        case 2:
            switch sender {
            case hMin:  ocv.hMin3 = value
            case hMax:  ocv.hMax3 = value
            case sMin:  ocv.sMin3 = value
            case sMax:  ocv.sMax3 = value
            case vMin:  ocv.vMin3 = value
            case vMax:  ocv.vMax3 = value
            default: break
        }

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
    
    
    @IBAction func pressedChangeServerAddressButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Server Address", message: "Enter the server's IP or local network address", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField { (textField) in
            textField.text = CommHanlder.sharedInstance.serverAddress
        }
        
        let updateAction = UIAlertAction(title: "Save", style: .default) { (action) in
            if let newAddress = alertController.textFields![0].text {
                CommHanlder.sharedInstance.serverAddress = newAddress
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(updateAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
