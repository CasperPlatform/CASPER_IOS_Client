//
//  DriveStream.swift
//  casper
//
//  Created by Pontus Pohl on 03/04/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import Foundation
import CocoaAsyncSocket


class DriveStream : NSObject, GCDAsyncUdpSocketDelegate {
    
    let HOST:String = "192.168.10.1"
    let PORT:UInt16    = 9997
    
    // Constants
    let TAG_DRIVE_WRITE:Int = 0xffff
    let FORWARD_FLAG        = 0x46
    let BACKWARD_FLAG       = 0x42
    let RIGHT_ANGLE_FLAG    = 0x52
    let LEFT_ANGLE_FLAG     = 0x4c
    let IDLE_DRIVE_FLAG     = 0x49
    
    var timer:NSTimer = NSTimer()
    let socketQueue : dispatch_queue_t
    var outSocket:GCDAsyncUdpSocket!
    var joystick :AnalogJoystick!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var token:NSString = ""
    //    var parent:SettingsViewController
    
    
    override init(){
        socketQueue = dispatch_queue_create("socketQueue", nil)
        //        self.parent = SettingsViewController()
        super.init()
        
        setupConnection()
    }
    init(joystick : AnalogJoystick){
       socketQueue = dispatch_queue_create("socketQueue", nil)
//        self.delegate = delegate
        super.init()
        self.joystick = joystick
        //setupConnection()
    }
    
    func setupConnection() -> Bool{
       
        outSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue:dispatch_get_main_queue())
        do {
            //            try inSocket.bindToPort(PORT)
            //            try inSocket.enableBroadcast(true)
            //            try inSocket.joinMulticastGroup(HOST)
            //            try inSocket.beginReceiving()
            
            try outSocket.enableBroadcast(true)
            try outSocket.connectToHost(HOST, onPort: PORT)
            try outSocket.beginReceiving()
            //try outSocket.connectToHost(HOST, onPort: PORT)
            
            if(self.userDefaults.objectForKey("token") as? String != ""){
                self.token = self.userDefaults.objectForKey("token") as! String
                print("token is"+(self.token as String))
                startWriting()
                
                return true
            }
            else{
                if(self.token as String != "test"){
                    print("token is empty")
                    return false
                }
            }
        } catch let error as NSError{
            print(error.localizedDescription)
            print("Something went wrong!")
            return false
        }
        
        return false
    }
    
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        print("connected")
        startWriting()
    }
    
    func startWriting(){
        print("Starting DriveWrite")
         self.timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("send"), userInfo: nil, repeats: true)
      
      
    }
  
    func getDriveMessage() -> NSData{
        
        // message carrier
        var message = [UInt8](count: 0, repeatedValue: 0)
        // token
        let tokenData = self.token.dataUsingEncoding(NSUTF8StringEncoding)
        // tokencount
        let count = tokenData!.length / sizeof(UInt8)
        // create array of appropriate length:
        var tokenArray = [UInt8](count: count, repeatedValue: 0)
        // copy bytes into array
        tokenData!.getBytes(&tokenArray, length:count * sizeof(UInt8))
        
        var x = (Float(joystick!.stick.position.x) / 60) * 90
        var y = (Float(joystick!.stick.position.y) / 60) * 90
        var fx = 0x52
        var fy = 0x46
        if( y < 0) {
            fy = 0x42
            y = y * -1
        }
        if( x < 0){
            fx = 0x4c
            x = x * -1
        }
        if(y == 0){
            fy = IDLE_DRIVE_FLAG;
        }
        if( x == 0){
            fx = IDLE_DRIVE_FLAG;
        }

        
        
        
        print(y)
        let angle = UInt8(x)
        let speed = UInt8(y)
        let flagDirectionY = UInt8(fy)
        let flagDirectionX = UInt8(fx)
        print(angle)
        print(speed)
        
        // append Drive-flag
        message.append(0x44)
        // append tokendata
        message.appendContentsOf(tokenArray)
      
        
        
        let driveBytes : [UInt8]  = [flagDirectionY,flagDirectionX,speed, angle, 0x0d, 0x0a, 0x04]
        message.appendContentsOf(driveBytes)
        print(message)
        let messageData = NSData(bytes: message, length: message.count * sizeof(UInt8))
        return messageData
    }
    
    func send(){
        
            let writeMsg = self.getDriveMessage()
            self.outSocket.sendData(writeMsg, withTimeout: 0, tag: self.TAG_DRIVE_WRITE)
        

        
    }
 
    func socket(sock: GCDAsyncSocket!, didWriteDataWithTag tag: Int) {
        print("GOT DRIVE CONF")
//        if(tag == TAG_DRIVE_WRITE){
//            
//            let driveMsg = getDriveMessage()
//            self.outSocket.writeData(driveMsg, withTimeout: 0, tag: TAG_DRIVE_WRITE)
//        }
    }
    func closeStream(){
//        let stopMsg = "stop"
//        let data = stopMsg.dataUsingEncoding(NSUTF8StringEncoding)
//        self.outSocket.sendData(data, withTimeout: 2, tag: 0)
        self.outSocket.close();
        self.timer.invalidate()
        
//    self.delegate = nil
        print("DriveStream Closed")
    }
  
}