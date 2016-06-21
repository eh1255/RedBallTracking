//
//  File.swift
//  RedBallTrackingiOS
//
//  Created by Erik Hornberger on 2016/06/21.
//  Copyright © 2016年 EExT. All rights reserved.
//

import Foundation
import OSCKit

class CommHanlder:NSObject, TargetUpdateDelegate {
    
    // Setup the singleton as the delegate for the shared instance of the OpenVCWrapper
    static let sharedInstance = CommHanlder()
    let client = OSCClient()
    
    // The server address is retrieved from and stored in NSUserDefaults
    // so that it is persisted between sessions
    var serverAddress:String {
        get { return NSUserDefaults.standardUserDefaults().stringForKey("serverAddress") ?? "" }
        set { NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "serverAddress")}
    }
    
    // This function will get called whenever an object is detected by the camera
    func targetCoordinatesChanged(xCoord: Int, screenCoordinates yCoord: Int) {
        sendCoordinates(x: xCoord, y: yCoord)
        print(xCoord)
        print(yCoord)
        print()
    }
    
    // Send the coordinates out to the server using the Open Sound Control protocol
    func sendCoordinates(x x:Int, y:Int) {
        let message = OSCMessage(address: "/redCoordinates", arguments: [x, y])
        client.sendMessage(message, to: serverAddress)
    }
}