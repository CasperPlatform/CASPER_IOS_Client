//
//  videoStream.swift
//  casper
//
//  Created by Pontus Pohl on 31/03/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import Foundation
import CocoaAsyncSocket


class VideoStream : NSObject, GCDAsyncUdpSocketDelegate, VideoStreamImageDelegate {
    
    let HOST:String = "192.168.10.1"
    let PORT:UInt16    = 6000
    let HEADER_FLAG:UInt8 = 0x01
    let PACKET_HEADER_FLAG:UInt8 = 0x02
    let socketQueue : dispatch_queue_t
    
    var timer = NSTimer()
    
    weak var delegate:VideoStreamDelegate?
    
    var outSocket:GCDAsyncUdpSocket!

    var uiImage:UIImage
    var count = 0
    var packageCount = 0
    
    var images = Array<VideoStreamImage>()
//    var parent:SettingsViewController
    
    
    override init(){
   
        self.uiImage    = UIImage()
//        self.parent = SettingsViewController()
        socketQueue = dispatch_queue_create("socketQueue", nil)
        super.init()
        
        setupConnection()
    }
    init(delegate: VideoStreamDelegate){
      
        self.uiImage    = UIImage()
        self.delegate = delegate
        socketQueue = dispatch_queue_create("socketQueue", nil)
        super.init()
        setupConnection()
    }
    
    func setupConnection(){
        
        
        outSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue:dispatch_get_main_queue())
        do {
//            try inSocket.bindToPort(PORT)
//            try inSocket.enableBroadcast(true)
//            try inSocket.joinMulticastGroup(HOST)
//            try inSocket.beginReceiving()
            try outSocket.enableBroadcast(true)
            try outSocket.connectToHost(HOST, onPort: PORT)
            try outSocket.beginReceiving()
            
            
            
            
            self.sendStart()
        } catch let error as NSError{
            print(error.localizedDescription)
            print("Something went wrong!")
        }
        
        print("Starting image show timer")
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("sendIdle"), userInfo: nil, repeats: true)
        
//        self.timer = NSTimer.init(timeInterval: 0.008, target: self, selector: Selector("showImage"), userInfo: nil, repeats: true)
//        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
        
    }
    
    // Receive data callback
    func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!, withFilterContext filterContext: AnyObject!) {
       

        print("current images.count =",images.count)
        
//        print("data received")
        let count = data.length / sizeof(UInt8)
        // create array of appropriate length:
        var byteArray = [UInt8](count: count, repeatedValue: 0)
        // copy bytes into array
        data.getBytes(&byteArray, length:count * sizeof(UInt8))
//        print(byteArray[0])
        // IF WE GOT HEADER
        if(byteArray[0] == HEADER_FLAG){
            
            
//            image.setData(NSData())
            
        
//            var imageImg = VideoStreamImage(header: data)
//            var imageNumber = Int(imageImg.getImageNumber())
            
            let imageNumber = extractImageNumber(byteArray,from:"imageHeader")
            var foundImage = false
            for image in images.reverse(){
                if( image.imageNumber == imageNumber){
                    image.addHeader(byteArray)
                    foundImage = true
                    break
                }
            }
            if(!foundImage) {
                print("adding image in block1")
                let image = VideoStreamImage(header: byteArray,delegate: self)
                print("With ",image.packageCount," Packages")
                images.append(image)
                
            }
            
            
            
            
            
//            var imageNr, byteCount : UInt32
//            // the number of elements:
//       
//            var imageNrArr = [UInt8](count: 4, repeatedValue: 0)
//            var byteCountArr = [UInt8](count: 4, repeatedValue: 0)
//         
//            
//            
//           
//           
//            imageNrArr   = Array(byteArray[2..<6])
//            byteCountArr = Array(byteArray[7..<11])
//            imageNr      = getNumberFromBytes(imageNrArr)
//            byteCount    = getNumberFromBytes(byteCountArr)
//            packageCount = Int(byteArray[6])
            
            
//            print("Flag 1 : ", byteArray[0])
//            print("Flag 2 : ", byteArray[1])
//            print("Image Number: ",imageNr)
//            print("nr of packets: ", packageCount)
//            print("nr of bytes in image: ",byteCount)
            
            
//            print(byteArray)
            }
        if(byteArray[0] == PACKET_HEADER_FLAG )
        {
//            self.count += 1
            
//            let imageNumber = Int(extractImageNumber(data, from: "packetHeader"))
            let imagePacket = VideoStreamImagePacket(data: byteArray)
            var imageNumber  = imagePacket.getImageNumber()
            var foundImage = false
            for image in images.reverse(){
                if( image.imageNumber == imageNumber){
                    print("adding package with number: ", imagePacket.getPacketNumber())
                    image.addPackage(imagePacket)
                    foundImage = true
                    break
                }
            }
            if(!foundImage) {
                print("adding image in block2")
                let image = VideoStreamImage(imageNr:UInt32(imageNumber),delegate: self)
                image.addPackage(imagePacket)
                images.append(image)
            }
        
//            var imageNrArr = [UInt8](count: 4, repeatedValue: 0)
//            imageNrArr   = Array(byteArray[1..<5])
//            imageNumber  = getNumberFromBytes(imageNrArr)
////            print("appending data of packet with info:")
//            
////            print("ImageNumber: ",imageNumber)
////            print("packageNumber", byteArray[5])
//            var dataToAppendArr:[UInt8] = Array(byteArray[6..<byteArray.count])
//            var dataToAppend = NSData(bytes: dataToAppendArr, length: dataToAppendArr.count)
            
//            image.appendData(dataToAppend)
            
        }
       
//        print(data.description)
//        print(address.description)
//        var datastring = NSString(data: data, encoding: NSASCIIStringEncoding)
//        print(datastring.debugDescription)
        
        
    }
    
    func DidCompleteImage(sender: VideoStreamImage, image: NSData) {
        print("Image Completed, in delagate method");
        
        if(self.images.count <= 0){
            return
        }
        print(images[0].isCompleteImage())
        for (index, image) in images.enumerate().reverse(){
            if(image.isCompleteImage()){
                print("found complete image")
                self.delegate?.DidReceiveImage(self, image: image.getImageData())
                self.images = Array(images[index..<images.count])
                print("Images length is now", self.images.count)
                break
                
            }
        }
    }
    
    
    // Depreceated, now using delegate instead
    func showImage(){
       
        if(self.images.count <= 0){
            return
        }
        print(images[0].isCompleteImage())
        for (index, image) in images.enumerate().reverse(){
            if(image.isCompleteImage()){
                print("found complete image")
                self.delegate?.DidReceiveImage(self, image: image.getImageData())
                self.images = Array(images[index..<images.count])
                print("Images length is now", self.images.count)
                break
                var foundLast = false
                var count     = 1
                while(!foundLast){
                    if(index - count >= 0)
                    {
                        if(!images[index-count].isCompleteImage())
                        {
                            foundLast = true
                            print("foundlast")
                        }
                        else
                        {
                            count+=1
                        }
                    }
                }
                self.delegate?.DidReceiveImage(self, image: images[(index-count)+1].getImageData())
                images = Array(images[((index-count)+1)..<images.count])
                break
            }
        }
        
//        for var i:Int = keys.count - 1 ; i >= 0 ;i -= 1 {
//            
//            if( images[keys[i]] != nil && images[keys[i]]!.isCompleteImage())
//            {
//                print("sending image to view")
//                self.delegate?.DidReceiveImage(self, image: images[keys[i]]!.getImageData())
//                
//                images.dropFirst(images.indexForKey(keys[i])?.successor())
//                
//                for (key, value) in images{
//                    print(key)
//                    if(key <= keys[i]){
//                        images.removeValueForKey(i)
//                    }
//                }
//               break
//            }
//        }
        
        
        
//        for i in 0...keys.count-1{
//           
////            print(images[i]!.isCompleteImage())
//            
//            if( images[keys[i]] != nil && images[keys[i]]!.isCompleteImage())
//            {
//                print("sending image to view")
//                self.delegate?.DidReceiveImage(self, image: images[keys[i]]!.getImageData())
//                for (key, value) in images{
//                    if(key <= keys[i]){
//                        images.removeValueForKey(i)
//                    }
//                }
//            }
//        }
//       self.delegate?.DidReceiveImage(self, image: self.image)
        

//        self.uiImage = UIImage(data: image)!
//        parent.imageView.image = self.uiImage
    }
    
    func sendStart(){
        
        var message = [UInt8](count: 0, repeatedValue: 0)
        var token = "a0733740b899d91f"
        var tokenData = token.dataUsingEncoding(NSUTF8StringEncoding)
        
        let count = tokenData!.length / sizeof(UInt8)
        // create array of appropriate length:
        var byteArray = [UInt8](count: count, repeatedValue: 0)
        // copy bytes into array
        tokenData!.getBytes(&byteArray, length:count * sizeof(UInt8))
        
        message.append(0x01)
        
        message.appendContentsOf(byteArray)
        message.append(0x53)
        
//        let data = message.dataUsingEncoding(NSUTF8StringEncoding)
        outSocket.sendData(NSData(bytes: message,length:message.count), withTimeout: 2, tag: 0)
        
        
        
    }
    func sendStop(){
        var message = [UInt8](count: 0, repeatedValue: 0)
        var token = "a0733740b899d91f"
        var tokenData = token.dataUsingEncoding(NSUTF8StringEncoding)
        
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
    func sendIdle(){
        var message = [UInt8](count: 0, repeatedValue: 0)
        var token = "a0733740b899d91f"
        var tokenData = token.dataUsingEncoding(NSUTF8StringEncoding)
        
        let count = tokenData!.length / sizeof(UInt8)
        // create array of appropriate length:
        var byteArray = [UInt8](count: count, repeatedValue: 0)
        // copy bytes into array
        tokenData!.getBytes(&byteArray, length:count * sizeof(UInt8))
        
        message.append(0x01)
        
        message.appendContentsOf(byteArray)
        message.append(0x49)
        
        //        let data = message.dataUsingEncoding(NSUTF8StringEncoding)
        outSocket.sendData(NSData(bytes: message,length:message.count), withTimeout: 2, tag: 0)
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
    func extractImageNumber(byteArray:Array<UInt8>, from: NSString) -> UInt32{
        
        
//        let count = data.length / sizeof(UInt8)
//        // create array of appropriate length:
//        var byteArray = [UInt8](count: count, repeatedValue: 0)
//        // copy bytes into array
//        data.getBytes(&byteArray, length:count * sizeof(UInt8))
        
        var imageNr: UInt32
        var imageNrArr =   [UInt8](count: 4, repeatedValue: 0)
        if(from.isEqualToString("imageHeader")){
            imageNrArr        = Array(byteArray[2..<6])
            return getNumberFromBytes(imageNrArr)

        }
        else if(from.isEqualToString("packetHeader")){
            imageNrArr        = Array(byteArray[1..<5])
            return getNumberFromBytes(imageNrArr)
        }
        else {
            return 0
        }
    }
    func udpSocketDidClose(sock: GCDAsyncUdpSocket!, withError error: NSError!) {
        
    }
    func closeStream(){
//        let stopMsg = "stop"
//        let data = stopMsg.dataUsingEncoding(NSUTF8StringEncoding)
//        self.outSocket.sendData(data, withTimeout: 2, tag: 0)
        self.sendStop()
        self.outSocket.closeAfterSending()
        self.delegate = nil
        self.timer.invalidate()
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