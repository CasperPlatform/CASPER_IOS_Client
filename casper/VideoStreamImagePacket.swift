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
}