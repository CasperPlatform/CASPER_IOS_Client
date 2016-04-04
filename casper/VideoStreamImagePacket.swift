//
//  VideoStreamImagePacket.swift
//  casper
//
//  Created by Pontus Pohl on 04/04/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import Foundation
class VideoStreamImagePacket : NSObject{
    var data         : NSData
    var packetHeader : NSData
    var packetData   : NSData
    var packetNumber : UInt8
    private var imageNumber  : UInt32 = 0
    
    override init(){
        self.packetHeader = NSData()
        self.packetData   = NSData()
        self.data         = NSData()
        self.packetNumber = 0
        super.init()
        
    }
    init(data : NSData){
        self.data = data
        self.packetHeader = NSData()
        self.packetData   = NSData()
        self.packetNumber = 0
        super.init()
        self.processData(data)
        
        
        
    }
    func processHeader(header : NSData){
        
    }
    func getImageNumber() -> UInt32{
        return self.imageNumber
    }
    func getImageData() -> NSData{
        return self.packetData
    }
    func processData(data:NSData){
        
        let count = data.length / sizeof(UInt8)
        
        // create array of appropriate length:
        var byteArray = [UInt8](count: count, repeatedValue: 0)
        data.getBytes(&byteArray, length:count * sizeof(UInt8))
        
        self.packetHeader = NSData(bytes: Array(byteArray[0..<6]), length: 6)
        self.packetNumber = byteArray[5]
        // copy bytes into array
        
        
        var imageNrArr = [UInt8](count: 4, repeatedValue: 0)
        imageNrArr   = Array(byteArray[1..<5])
        self.imageNumber = getNumberFromBytes(imageNrArr)
        
        let dataToAppendArr:[UInt8] = Array(byteArray[6..<byteArray.count])
        self.packetData = NSData(bytes: dataToAppendArr, length: dataToAppendArr.count)
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

}