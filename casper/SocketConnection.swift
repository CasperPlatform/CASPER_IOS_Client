//
//  SocketConnection.swift
//  casper
//
//  Created by Pontus Pohl on 20/02/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
class SocketConnection:NSObject, NSStreamDelegate{
    
    private var driveInputStream: NSInputStream!
    private var driveOutputStream: NSOutputStream!
    private var videoInputStream: NSInputStream!
    private var videoOutputStream: NSOutputStream!
    private var udpSocketConnection:GCDAsyncUdpSocket!
    let driveHost:CFStringRef = "127.0.0.1"
    let drivePort:UInt32 = 9999
    let videoHost:CFStringRef = "192.168.0.105"
    let videoPort:UInt32 = 9998
    
    var timer = NSTimer()
    var flagx = UInt8(0)
    var flagy = UInt8(0)
    var speed = UInt8(0)
    var angle = UInt8(0)
    
    var dataToStream: NSData!
    
    var byteIndex: Int!
    
    
    override init(){
        super.init()
    }
    deinit {
        print("deIniting")
        // perform the deinitialization
    }
    
    func OpenVideoStream(){
      
        
//        print("opening videoStream")
//        var readStream:  Unmanaged<CFReadStream>?
//        var writeStream: Unmanaged<CFWriteStream>?
//        
//        
//        CFStreamCreatePairWithSocketToHost(nil, videoHost, videoPort, &readStream, &writeStream)
//        
//        
//
//        
//        self.videoInputStream = readStream!.takeRetainedValue()
//        self.videoOutputStream = writeStream!.takeRetainedValue()
//        
//        
//        self.videoInputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
//        self.videoOutputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
//        
//        self.videoInputStream.delegate = self
//        self.videoOutputStream.delegate = self
//        
//        //inputStream.open()
//        //outputStream.open()
//        self.videoInputStream.open()
//        self.videoOutputStream.open()
        
        
        
        
        
       
        
        
    }
    func stream(stream: NSStream, handleEvent eventCode: NSStreamEvent) {
        if( stream == self.videoOutputStream)
        {
            if( eventCode == NSStreamEvent.HasSpaceAvailable){
                
                print("sending bogus")
                
                var bytes : [UInt8]  = [0x44,self.flagy,self.flagx,self.speed, self.angle, 0x0d, 0x0a, 0x04]
                
                print(bytes)
                var values = NSData(bytes: bytes, length: bytes.count * sizeof(UInt8))
                
                var readBytes = values.bytes
                var dataLength = values.length
               
                var buffer = Array<UInt8>(count: dataLength, repeatedValue: 0)
                memcpy(UnsafeMutablePointer(buffer), readBytes, dataLength)
                var len = self.videoOutputStream.write(buffer, maxLength: dataLength)
                
                //outputStream.close()
                //outputStream.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
                //outputStream = nil
            }
            
            if eventCode == NSStreamEvent.EndEncountered{
                print("end Encountered")
                self.videoOutputStream.close()
                self.videoOutputStream.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
                self.videoOutputStream = nil
            }
            
            
            
        }
        if( stream == self.videoInputStream){
            
            if( eventCode == NSStreamEvent.HasBytesAvailable){
                print("got data")
            
            }
            if eventCode == NSStreamEvent.EndEncountered{
                print("end Encountered")
                self.videoOutputStream.close()
                self.videoOutputStream.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
                self.videoOutputStream = nil
            }
            
        }
        print("stream event")
    }
    
    
    func openStreamAndSendValues(){
        
        
        
        
        
            var readStream:  Unmanaged<CFReadStream>?
            var writeStream: Unmanaged<CFWriteStream>?
            
            CFStreamCreatePairWithSocketToHost(nil, driveHost, drivePort, &readStream, &writeStream)
            
            self.driveInputStream = readStream!.takeRetainedValue()
            self.driveOutputStream = writeStream!.takeRetainedValue()
            
            //inputStream.open()
            //outputStream.open()
            self.driveInputStream.open()
            self.driveOutputStream.open()
        
      
        
       
        
        
//        var speedVal:[UInt8] = [speed]
//        var directionVal:[UInt8] = [direction]
//        var dict: Dictionary<String,Array<UInt8>> = [:]
//        
//        
//        dict["direction"] = directionVal
//        dict["speed"] = speedVal
//        
//        var values2 = NSMutableArray()
       
    }

    func closeDriveStream(){
        print("closing stream")
        self.driveInputStream.close()
        self.driveOutputStream.close()
    }
    func closeVideoStream(){
        self.videoInputStream.close()
        self.videoOutputStream.close()
    }
    
    func sendValue(timer: NSTimer){
        
        if(self.driveOutputStream == nil){
            print("stream is null, reAllocating")
            openStreamAndSendValues()
            return
        }
        if(self.driveOutputStream.streamStatus == NSStreamStatus.Closed ||
        self.driveOutputStream.streamStatus == NSStreamStatus.Error){
            openStreamAndSendValues()
            print("is error or closed")
            return
        }
        
        let joystick = timer.userInfo as? AnalogJoystick
        
        //timer.invalidate()
        if( joystick == nil){
            print("joystick is nil")
            return
        }
        
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
        
        
        self.flagx = flagDirectionX
        self.flagy = flagDirectionY
        self.speed = speed
        self.angle = angle
        
        var bytes : [UInt8]  = [0x44,self.flagy,self.flagx,self.speed, self.angle, 0x0d, 0x0a, 0x04]
        
        print(bytes)
        var values = NSData(bytes: bytes, length: bytes.count * sizeof(UInt8))
        
      
        
        if(self.driveOutputStream.hasSpaceAvailable){
           
            print("sending")
            
            
//
//            
//            var bytes = [UInt8](count: datarec!.length, repeatedValue: 0)
//            datarec!.getBytes(&bytes, length: bytes.count)
            
            
            
            
           
//            var arr : [UInt8] = [0x54,0x64,0x04];
            
//            let data = NSData(bytes: arr, length: arr.count * sizeof(UInt8))
            
            var readBytes = values.bytes
            var dataLength = values.length
            
            var buffer = Array<UInt8>(count: dataLength, repeatedValue: 0)
            memcpy(UnsafeMutablePointer(buffer), readBytes, dataLength)
            print(buffer)
            var len = self.driveOutputStream.write(buffer, maxLength: dataLength)
            
            
            
            
        }
        if(self.driveOutputStream.streamStatus == NSStreamStatus.Error){
            print("error")
            closeDriveStream()
            
            self.timer.invalidate()
        }
        
        
        
        
    }
    
    
}