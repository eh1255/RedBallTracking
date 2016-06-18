//
//  ViewController.swift
//  RedBallTrackingiOS
//
//  Created by Erik Hornberger on 2016/06/18.
//  Copyright © 2016年 EExT. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Starting the camera immediately in viewDidLoad, so I just tossed in a delay to give the views time to load up
        // You could do it in viewDidAppear as well, but that can get called multiple times. This solution doesn't require any extra variables
        performSelector(#selector(startCamera), withObject: nil, afterDelay: 2.5)
    }
    
    func startCamera() {
         OpenCVWrapper.sharedInstance().setupVideoCamera(imageView)
    }
    
    @IBAction func showSettings(sender: AnyObject) {
        // Present the settings controller in a popover view
        let settingsController = storyboard?.instantiateViewControllerWithIdentifier("Settings") as! SettingsViewController
        
        let formSheetController   = MZFormSheetPresentationViewController(contentViewController: settingsController)
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.presentationController?.backgroundColor = UIColor.clearColor()
        formSheetController.presentationController?.contentViewSize = CGSizeMake(view.frame.width*0.85, view.frame.height*0.65)
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
}

