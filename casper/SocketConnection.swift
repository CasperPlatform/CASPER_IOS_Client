//
//  SocketConnection.swift
//  casper
//
//  Created by Pontus Pohl on 20/02/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import Foundation
class SocketConnection:NSObject, NSStreamDelegate{
    
    private var inputStream: NSInputStream!
    private var outputStream: NSOutputStream!
    let host:CFStringRef = "192.168.10.1"
    let port:UInt32 = 9999
    
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
    
    func Open(){
      
        
        
        var readStream:  Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        
        CFStreamCreatePairWithSocketToHost(nil, host, port, &readStream, &writeStream)
        
        

        
        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()
        
        
        self.inputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.outputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        self.inputStream.delegate = self
        self.outputStream.delegate = self
        
        //inputStream.open()
        //outputStream.open()
        self.inputStream.open()
        self.outputStream.open()
        
        
        
        
        
       
        
        
    }
    func stream(stream: NSStream, handleEvent eventCode: NSStreamEvent) {
        if( stream == self.outputStream)
        {
            if( eventCode == NSStreamEvent.HasSpaceAvailable){
                
//                dataToStream = sendValue()
//                var readBytes = dataToStream.bytes
//                var dataLength = dataToStream.length
//               
//                var buffer = Array<UInt8>(count: dataLength, repeatedValue: 0)
//                memcpy(UnsafeMutablePointer(buffer), readBytes, dataLength)
//                var len = outputStream.write(buffer, maxLength: dataLength)
                
                //outputStream.close()
                //outputStream.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
                //outputStream = nil
            }
            
            if eventCode == NSStreamEvent.EndEncountered{
                print("end Encountered")
                outputStream.close()
                outputStream.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
                outputStream = nil
            }
            
            
        }
        print("stream event")
    }
    
    
    func openStreamAndSendValues(){
        
        
        
        
        
            var readStream:  Unmanaged<CFReadStream>?
            var writeStream: Unmanaged<CFWriteStream>?
            
            CFStreamCreatePairWithSocketToHost(nil, host, port, &readStream, &writeStream)
            
            self.inputStream = readStream!.takeRetainedValue()
            self.outputStream = writeStream!.takeRetainedValue()
            
            //inputStream.open()
            //outputStream.open()
            self.inputStream.open()
            self.outputStream.open()
        
      
        
       
        
        
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

    func closeStream(){
        print("closing stream")
        self.inputStream.close()
        self.outputStream.close()
        
    }
    
    func sendValue(timer: NSTimer){
        
        if(outputStream == nil){
            print("stream is null, reAllocating")
            openStreamAndSendValues()
            return
        }
        if(outputStream.streamStatus == NSStreamStatus.Closed ||
        outputStream.streamStatus == NSStreamStatus.Error){
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
        
        var x = (Float(joystick!.stick.position.x) / 40) * 90
        var y = (Float(joystick!.stick.position.y) / 40) * 255
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
        
        var bytes : [UInt8]  = [0x44,self.flagy,self.flagx,self.speed, self.angle, 0x0d, 0x0a]
        
        print(bytes)
        var values = NSData(bytes: bytes, length: bytes.count * sizeof(UInt8))
        
      
        
        if(self.outputStream.hasSpaceAvailable){
           
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
            var len = self.outputStream.write(buffer, maxLength: dataLength)
            
            
            
            
        }
        if(self.outputStream.streamStatus == NSStreamStatus.Error){
            print("error")
            self.inputStream.close()
            self.outputStream.close()
            self.timer.invalidate()
        }
        
        
        
        
    }
    
    
}