//
//  File.swift
//  RedBallTrackingiOS
//
//  Created by Erik Hornberger on 2016/06/21.
//  Copyright © 2016年 EExT. All rights reserved.
//

import Foundation

class CommHanlder:NSObject, TargetUpdateDelegate {
    
    // Setup the singleton as the delegate for the shared instance of the OpenVCWrapper
    static let sharedInstance = CommHanlder()
    
    // This function will get called whenever an object is detected by the camera
    func targetCoordinatesChanged(xCoord: Int, screenCoordinates yCoord: Int) {
        print(xCoord)
        print(yCoord)
        print()
    }
}