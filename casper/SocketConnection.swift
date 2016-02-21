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
    
    
    var dataToStream: NSData!
    
    var byteIndex: Int!
    
    func Connect(){
        
        let host:CFStringRef = "127.0.0.1"
        let port:UInt32 = 9999
        
        
        var readStream:  Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        
        CFStreamCreatePairWithSocketToHost(nil, host, port, &readStream, &writeStream)
        
        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()
        
        
        self.inputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.outputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        self.inputStream.delegate = self
        self.outputStream.delegate = self
        
        inputStream.open()
        outputStream.open()
        
        self.inputStream.open()
        self.outputStream.open()
        
        
    }
    func stream(stream: NSStream, handleEvent eventCode: NSStreamEvent) {
        if( stream == self.outputStream)
        {
            if( eventCode == NSStreamEvent.HasSpaceAvailable){
                dataToStream = sendValue()
                var readBytes = dataToStream.bytes
                var dataLength = dataToStream.length
               
                var buffer = Array<UInt8>(count: dataLength, repeatedValue: 0)
                memcpy(UnsafeMutablePointer(buffer), readBytes, dataLength)
                var len = outputStream.write(buffer, maxLength: dataLength)
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
    
    func sendValue()->NSData{
        
        var arr : [UInt8] = [0x4f,0x6f,0xcf,0x04];
        
        let data = NSData(bytes: arr, length: arr.count * sizeof(UInt8))
        
        return data

     
        
    }
    
    
}