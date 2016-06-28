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
    
    // Initialize the client on port 9000
    let client:F53OSCClient = {
        let client = F53OSCClient.init()
        client.port = 9000
        return client
    }()
    
    // The server address is retrieved from and stored in NSUserDefaults
    // so that it is persisted between sessions
    var serverAddress:String {
        get { return NSUserDefaults.standardUserDefaults().stringForKey("serverAddress") ?? "" }
        set { NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "serverAddress")}
    }
    
    // This function will get called whenever an object is detected by the camera
    func targetCoordinatesChanged(xCoord: Int, screenCoordinates yCoord: Int) {
        sendCoordinates(x: xCoord, y: yCoord)
    }
    
    // Send the coordinates out to the server using the Open Sound Control protocol
    func sendCoordinates(x x:Int, y:Int) {
        client.host = serverAddress
        let message = F53OSCMessage(addressPattern: "/redCoordinates", arguments: [x,y])
        client.sendPacket(message)
        
        print(x)
        print(y)
        print()
    }
}