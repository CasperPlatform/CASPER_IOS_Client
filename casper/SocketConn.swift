//
//  SocketConn.swift
//  casper
//
//  Created by Pontus Pohl on 28/02/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//
//
//import Foundation
//
//
//
//
//class SocketConn:NSObject, NSStreamDelegate{
//
//    
//private var input: NSInputStream?
//private var output: NSOutputStream?
//
//
//var dataToStream: NSData!
//
//var byteIndex: Int!
//
//func Connect(){
//    
//    let host:CFStringRef = "127.0.0.1"
//    let port:UInt32 = 9999
//    
//    
//   
//    
//  
//    
//    
//    NSStream.getStreamsToHostWithName(host as String, port: 9999, inputStream: &input, output: &outputStream)
//    
//    let inputStream = input!
//    let outputStream = output!
//    
//    self.inputStream = readStream!.takeRetainedValue()
//    self.outputStream = writeStream!.takeRetainedValue()
//    
//    
//    self.inputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
//    self.outputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
//    
//    self.inputStream.delegate = self
//    self.outputStream.delegate = self
//    
//    //inputStream.open()
//    //outputStream.open()
//    self.inputStream.open()
//    self.outputStream.open()
//    
//    
//    dataToStream = sendValue()
//    var readBytes = dataToStream.bytes
//    var dataLength = dataToStream.length
//    
//    var buffer = Array<UInt8>(count: dataLength, repeatedValue: 0)
//    memcpy(UnsafeMutablePointer(buffer), readBytes, dataLength)
//    var len = self.outputStream.write(buffer, maxLength: dataLength)
//    
//    }   
//}