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
    let oscClient = F53OSCClient.init()
    
    // The server address is retrieved from and stored in NSUserDefaults
    // so that it is persisted between sessions
    var serverAddress:String {
        get { return UserDefaults.standard.string(forKey: "serverAddress") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "serverAddress")}
    }
    
    // These functions will get called whenever an object is detected by the camera
    func targetCoordinatesChangedRED(_ xCoord: Int, screenCoordinates yCoord: Int) {
        sendCoordinatesRED(x: xCoord, y: yCoord)
    }
    
    func targetCoordinatesChangedBLUE(_ xCoord: Int, screenCoordinates yCoord: Int) {
        sendCoordinatesBLUE(x: xCoord, y: yCoord)
    }
    
    func targetCoordinatesChangedYELLOW(_ xCoord: Int, screenCoordinates yCoord: Int) {
        sendCoordinatesYELLOW(x: xCoord, y: yCoord)
    }
    
    // Send the coordinates out to the server using the Open Sound Control protocol
    func sendCoordinatesRED(x:Int, y:Int) {
        let message = F53OSCMessage(addressPattern: serverAddress, arguments: [x, y])
        
        oscClient.host = serverAddress
        oscClient.port = 9000
        oscClient.send(message)
    }
    
    func sendCoordinatesBLUE(x:Int, y:Int) {
        let message = F53OSCMessage(addressPattern: serverAddress, arguments: [x, y])
        
        oscClient.host = serverAddress
        oscClient.port = 9000
        oscClient.send(message)
    }
    
    func sendCoordinatesYELLOW(x:Int, y:Int) {
        let message = F53OSCMessage(addressPattern: serverAddress, arguments: [x, y])
        
        oscClient.host = serverAddress
        oscClient.port = 9000
        oscClient.send(message)
    }
}
