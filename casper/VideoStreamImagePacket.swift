//
//  VideoStreamImagePacket.swift
//  casper
//
//  Created by Pontus Pohl on 04/04/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import Foundation
class VideoStreamImagePacket : NSObject{
    
    var packetHeader : NSData
    var packetData   : NSData
    
    override init(){
        self.packetHeader = NSData()
        self.packetData   = NSData()
        super.init()
        
    }
    init(header: NSData, data : NSData){
        self.packetHeader = header
        self.packetData = data
    }
    func processHeader(header : NSData){
        
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