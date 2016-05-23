//
//  LidarMapper.swift
//  casper
//
//  Created by Pontus Pohl on 24/04/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class LidarMapper : NSObject, GCDAsyncUdpSocketDelegate{
    let HOST:String = "devpi.smallwhitebird.org"
    let PORT:UInt16    = 9998
    var outSocket:GCDAsyncUdpSocket!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var token:NSString = ""
    
    weak var delegate:LidarMapperDelegate?
    
    init(delegate: LidarMapperDelegate){
        
        self.delegate = delegate
        super.init()
        
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
            
            
            
            if(self.userDefaults.objectForKey("token") as? String != ""){
                self.token = self.userDefaults.objectForKey("token") as! String
                print("token is"+(self.token as String))
                self.sendStart()
                print("Starting idle message timer")
            
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
    func sendStop(){
        var message = [UInt8](count: 0, repeatedValue: 0)
        //        var token = "a71d1842e87c0aa2"
        var tokenData = self.token.dataUsingEncoding(NSUTF8StringEncoding)
        
        let count = tokenData!.length / sizeof(UInt8)
        // create array of appropriate length:
        var byteArray = [UInt8](count: count, repeatedValue: 0)
        // copy bytes into array
        tokenData!.getBytes(&byteArray, length:count * sizeof(UInt8))
        
        message.append(0x01)
        
        message.appendContentsOf(byteArray)
        message.append(0x73)
        
        //        let data = message.dataUsingEncoding(NSUTF8StringEncoding)
        outSocket.sendData(NSData(bytes: message,length:message.count), withTimeout: 2, tag: 0)
    }
    func sendStart(){
        print("sending start")
        var message = [UInt8](count: 0, repeatedValue: 0)
        
        //        var token = "a71d1842e87c0aa2"
        let tokenData = self.token.dataUsingEncoding(NSUTF8StringEncoding)
        
        let count = tokenData!.length / sizeof(UInt8)
        // create array of appropriate length:
        var byteArray = [UInt8](count: count, repeatedValue: 0)
        // copy bytes into array
        tokenData!.getBytes(&byteArray, length:count * sizeof(UInt8))
        
        message.append(0x4c)
        message.append(0x53)
        message.appendContentsOf(byteArray)
       
        let msgEnd : [UInt8]  = [0x0d, 0x0a, 0x04]
        message.appendContentsOf(msgEnd)
        //        let data = message.dataUsingEncoding(NSUTF8StringEncoding)
        outSocket.sendData(NSData(bytes: message,length:message.count), withTimeout: 2, tag: 0)
    }
    func closeStream(){
        //        let stopMsg = "stop"
        //        let data = stopMsg.dataUsingEncoding(NSUTF8StringEncoding)
        //        self.outSocket.sendData(data, withTimeout: 2, tag: 0)
        self.sendStop()
        self.outSocket.closeAfterSending()
        self.delegate = nil
        print("lidarMapper Closed")
    }
    
}