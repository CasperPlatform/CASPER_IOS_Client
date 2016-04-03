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
    let HEADER_FLAG:UInt8 = 0x01
    let PACKET_HEADER_FLAG:UInt8 = 0x02
    
    weak var delegate:VideoStreamDelegate?
    var inSocket:GCDAsyncUdpSocket!
    var outSocket:GCDAsyncUdpSocket!
    var image:NSMutableData
    var uiImage:UIImage
    var count = 0
    var packageCount = 0
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
       

      
        
        print("data received")
        let count = data.length / sizeof(UInt8)
        // create array of appropriate length:
        var byteArray = [UInt8](count: count, repeatedValue: 0)
        // copy bytes into array
        data.getBytes(&byteArray, length:count * sizeof(UInt8))
        print(byteArray[0])
        // IF WE GOT HEADER
        if(byteArray[0] == HEADER_FLAG){
            
            image.setData(NSData())
            var imageNr, byteCount : UInt32
            // the number of elements:
       
            var imageNrArr = [UInt8](count: 4, repeatedValue: 0)
            var byteCountArr = [UInt8](count: 4, repeatedValue: 0)
         
            
            
           
           
            imageNrArr   = Array(byteArray[2..<6])
            byteCountArr = Array(byteArray[7..<11])
            imageNr      = getNumberFromBytes(imageNrArr)
            byteCount    = getNumberFromBytes(byteCountArr)
            packageCount = Int(byteArray[6])
            
            
            print("Flag 1 : ", byteArray[0])
            print("Flag 2 : ", byteArray[1])
            print("Image Number: ",imageNr)
            print("nr of packets: ", packageCount)
            print("nr of bytes in image: ",byteCount)
            
            
            print(byteArray)
            }
        if(byteArray[0] == PACKET_HEADER_FLAG )
        {
            self.count += 1
            var imageNumber: UInt32
            var imageNrArr = [UInt8](count: 4, repeatedValue: 0)
            imageNrArr   = Array(byteArray[1..<5])
            imageNumber  = getNumberFromBytes(imageNrArr)
            print("appending data of packet with info:")
            
            print("ImageNumber: ",imageNumber)
            print("packageNumber", byteArray[5])
            var dataToAppendArr:[UInt8] = Array(byteArray[6..<byteArray.count])
            var dataToAppend = NSData(bytes: dataToAppendArr, length: dataToAppendArr.count)
            image.appendData(dataToAppend)
            
        }
        if(self.count == packageCount){
            print("creating image")
            createImg()
            self.count = 0
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
    func getNumberFromBytes(array:[UInt8]) ->UInt32{
        let first,second,third,fourth, imageNr:UInt32
        
        first  = UInt32(array[0])
        second = UInt32(array[1])
        third  = UInt32(array[2])
        fourth = UInt32(array[3])
        
        imageNr = first<<24 | second<<16 | third<<8 | fourth;
        return imageNr
    }
    func udpSocketDidClose(sock: GCDAsyncUdpSocket!, withError error: NSError!) {
        
    }
    func closeStream(){
        let stopMsg = "stop"
        let data = stopMsg.dataUsingEncoding(NSUTF8StringEncoding)
        self.outSocket.sendData(data, withTimeout: 2, tag: 0)
        self.outSocket.closeAfterSending()
        self.delegate = nil
        print("videoStream Closed")
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