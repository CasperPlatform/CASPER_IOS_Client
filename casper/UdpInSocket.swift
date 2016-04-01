//
//  UdpInSocket.swift
//  casper
//
//  Created by Pontus Pohl on 06/03/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
class UdpInSocket: NSObject, GCDAsyncUdpSocketDelegate {
    
    let IP = "255.255.255.255"
    let PORT:UInt16 = 5556
    var socket:GCDAsyncUdpSocket!
    
    override init(){
        super.init()
        setupConnection()
    }
    
    func setupConnection(){
        var error : NSError?
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        socket.bindToPort(PORT)
        socket.enableBroadcast(true, error: &error)
        
        socket.beginReceiving()
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!,      withFilterContext filterContext: AnyObject!) {
        println("incoming message: \(data)");
    }
}