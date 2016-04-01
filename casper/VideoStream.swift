//
//  videoStream.swift
//  casper
//
//  Created by Pontus Pohl on 31/03/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import Foundation
import CocoaAsyncSocket


class VideoStream : NSObject, GCDAsyncUdpSocketDelegate {
    
    let HOST:String = "127.0.0.1"
    let PORT:UInt16    = 6000
    let HEADER_LENGTH = 11
    let PACKET_HEADER_LENGTH = 8
    
    weak var delegate:VideoStreamDelegate?
    var inSocket:GCDAsyncUdpSocket!
    var outSocket:GCDAsyncUdpSocket!
    var image:NSMutableData
    var uiImage:UIImage
    var count = 0
//    var parent:SettingsViewController
    
    
    override init(){
        self.image      = NSMutableData()
        self.uiImage    = UIImage()
//        self.parent = SettingsViewController()
        super.init()
        
        setupConnection()
    }
    init(delegate: VideoStreamDelegate){
        self.image      = NSMutableData()
        self.uiImage    = UIImage()
        self.delegate = delegate
//        self.parent = parent
        super.init()
        setupConnection()
        
    }
    
    func setupConnection(){
        
        inSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        outSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        do {
//            try inSocket.bindToPort(PORT)
//            try inSocket.enableBroadcast(true)
//            try inSocket.joinMulticastGroup(HOST)
//            try inSocket.beginReceiving()
            try outSocket.enableBroadcast(true)
            try outSocket.connectToHost(HOST, onPort: PORT)
            try outSocket.beginReceiving()
        } catch let error as NSError{
            print(error.localizedDescription)
            print("Something went wrong!")
        }
        
        
    }
    
    // Receive data callback
    func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!, withFilterContext filterContext: AnyObject!) {
       

        count += 1
        print("data received")
        
        // IF WE GOT HEADER
        if(data.length == 11){
            
            var imageNr : UInt32
            // the number of elements:
            let count = data.length / sizeof(UInt8)
            
            
            // create array of appropriate length:
            var byteArray = [UInt8](count: count, repeatedValue: 0)
            
            // copy bytes into array
            data.getBytes(&byteArray, length:count * sizeof(UInt8))
            imageNr = getNumberFromBytes(byteArray)
            print("Flag 1 : ",byteArray[0])
            print("Image Number",imageNr)
            print("nr of packets")
            print(byteArray)
            }
        if(data.length > 11)
        {
            image.appendData(data)
        }
        if(count == 25){
            createImg()
        }
//        print(data.description)
//        print(address.description)
//        var datastring = NSString(data: data, encoding: NSASCIIStringEncoding)
//        print(datastring.debugDescription)
        
        
    }
    func createImg(){
        self.delegate?.DidReceiveImage(self, image: image)
//        self.uiImage = UIImage(data: image)!
//        parent.imageView.image = self.uiImage
    }
    
    func send(message:String){
        let data = message.dataUsingEncoding(NSUTF8StringEncoding)
        outSocket.sendData(data, withTimeout: 2, tag: 0)
    }
    func getNumberFromBytes(imgNumber:[UInt8]) ->UInt32{
        let first,second,third,fourth, imageNr:UInt32
        
        first  = UInt32(imgNumber[2])
        second = UInt32(imgNumber[3])
        third  = UInt32(imgNumber[4])
        fourth = UInt32(imgNumber[5])
        
        imageNr = first<<24 | second<<16 | third<<8 | fourth;
        return imageNr
    }
    func udpSocket(sock: GCDAsyncUdpSocket!, didConnectToAddress address: NSData!) {
        print("didConnectToAddress");
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didNotConnect error: NSError!) {
        print("didNotConnect \(error)")
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didSendDataWithTag tag: Int) {
        print("didSendDataWithTag")
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didNotSendDataWithTag tag: Int, dueToError error: NSError!) {
        print("didNotSendDataWithTag")
    }
}