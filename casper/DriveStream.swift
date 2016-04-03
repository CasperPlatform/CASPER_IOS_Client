//
//  DriveStream.swift
//  casper
//
//  Created by Pontus Pohl on 03/04/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import Foundation
import CocoaAsyncSocket


class DriveStream : NSObject, GCDAsyncSocketDelegate {
    
    let HOST:String = "192.168.10.1"
    let PORT:UInt16    = 9999
    let TAG_DRIVE_WRITE:Int = 0xffff
 
    var outSocket:GCDAsyncSocket!
    var joystick :AnalogJoystick!
    //    var parent:SettingsViewController
    
    
    override init(){
    
        //        self.parent = SettingsViewController()
        super.init()
        
        setupConnection()
    }
    init(joystick : AnalogJoystick){
       
//        self.delegate = delegate
        super.init()
        self.joystick = joystick
        setupConnection()
    }
    
    func setupConnection(){
       
        outSocket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        do {
            //            try inSocket.bindToPort(PORT)
            //            try inSocket.enableBroadcast(true)
            //            try inSocket.joinMulticastGroup(HOST)
            //            try inSocket.beginReceiving()
            
            try outSocket.connectToHost(HOST, onPort: PORT)
            startWriting()
        } catch let error as NSError{
            print(error.localizedDescription)
            print("Something went wrong!")
        }
        
        
    }
    
    func startWriting(){
        print("Starting DriveWrite")
        let writeMsg = getDriveMessage()
        outSocket.writeData(writeMsg, withTimeout: 0, tag: TAG_DRIVE_WRITE)
    }
  
    func getDriveMessage() -> NSData{
        
        
        
        var x = (Float(joystick!.stick.position.x) / 60) * 90
        var y = (Float(joystick!.stick.position.y) / 60) * 255
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
        
        
        print(y)
        let angle = UInt8(x)
        let speed = UInt8(y)
        let flagDirectionY = UInt8(fy)
        let flagDirectionX = UInt8(fx)
        print(angle)
        print(speed)
        
        
       
        
        let bytes : [UInt8]  = [0x44,flagDirectionY,flagDirectionX,speed, angle, 0x0d, 0x0a, 0x04]
        
        print(bytes)
        let values = NSData(bytes: bytes, length: bytes.count * sizeof(UInt8))
        return values
    }
    
    func send(message:String){
//        let data = message.dataUsingEncoding(NSUTF8StringEncoding)
//        outSocket.sendData(data, withTimeout: 2, tag: 0)
    }
 
    func socket(sock: GCDAsyncSocket!, didWriteDataWithTag tag: Int) {
        print("GOT DRIVE CONF")
        if(tag == TAG_DRIVE_WRITE){
            
            let driveMsg = getDriveMessage()
            self.outSocket.writeData(driveMsg, withTimeout: 0, tag: TAG_DRIVE_WRITE)
        }
    }
    func closeStream(){
//        let stopMsg = "stop"
//        let data = stopMsg.dataUsingEncoding(NSUTF8StringEncoding)
//        self.outSocket.sendData(data, withTimeout: 2, tag: 0)
        self.outSocket.disconnectAfterWriting()
//        self.delegate = nil
        print("DriveStream Closed")
    }
  
}