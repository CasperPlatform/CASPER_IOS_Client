//
//  LidarMapperPacket.swift
//  casper
//
//  Created by Marco Koivisto on 2016-05-23.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import Foundation
class LidarMapperPacket : NSObject{
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
    init(data : Array<UInt8>){
        self.data = NSData(bytes: data, length: data.count)
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
    func getPacketData() -> NSData{
        return self.packetData
    }
    func processData(data:Array<UInt8>){
        
        
        self.packetHeader = NSData(bytes: Array(data[0..<6]), length: 6)
        self.packetNumber = data[5]
        //        print("Adding PacketNumber: ",self.packetNumber)
        // copy bytes into array
        
        
        var imageNrArr = [UInt8](count: 4, repeatedValue: 0)
        imageNrArr   = Array(data[1..<5])
        self.imageNumber = getNumberFromBytes(imageNrArr)
        
        let dataToAppendArr:[UInt8] = Array(data[6..<data.count])
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
    func getPacketNumber() -> UInt8{
        return self.packetNumber
    }
    
}