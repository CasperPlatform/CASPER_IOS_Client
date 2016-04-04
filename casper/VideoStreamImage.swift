//
//  VideoStreamImage.swift
//  casper
//
//  Created by Pontus Pohl on 04/04/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import Foundation
class VideoStreamImage : NSObject {
    
    var packageCount : UInt32 = 0
    var packages = Array<VideoStreamImagePacket>()
    var packageNumber :UInt32
    var byteCount         :UInt32
    var imageNumber   :UInt32
    var imageData     :NSMutableData = NSMutableData()
    
    
    override init(){
        self.packageNumber = 0
        self.byteCount     = 0
        self.imageNumber   = 0
        super.init()
    }
    init(header: NSData){
       
        self.packageNumber = 0
        self.byteCount     = 0
        self.imageNumber   = 0
        super.init()
        processHeader(header)
    }
    init(imageNr:UInt32){
        self.packageNumber = 0
        self.byteCount     = 0
        self.imageNumber   = imageNr
        super.init()
    }
    func addPackage(package: VideoStreamImagePacket){
        
    }
    func addHeader(header: NSData){
        processHeader(header)
    }
    func isComplete() -> Bool{
        
        return false
    }
    func processHeader(header : NSData){
        let count = header.length / sizeof(UInt8)
        // create array of appropriate length:
        var byteArray = [UInt8](count: count, repeatedValue: 0)
        // copy bytes into array
        header.getBytes(&byteArray, length:count * sizeof(UInt8))
        print(byteArray[0])
        
        var imageNr, byteCount : UInt32
        // the number of elements:
        
        var imageNrArr =   [UInt8](count: 4, repeatedValue: 0)
        var byteCountArr = [UInt8](count: 4, repeatedValue: 0)
        
        imageNrArr        = Array(byteArray[2..<6])
        byteCountArr      = Array(byteArray[7..<11])
        self.imageNumber  = getNumberFromBytes(imageNrArr)
        self.byteCount    = getNumberFromBytes(byteCountArr)
        self.packageCount = UInt32(byteArray[6])
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
    func getImageNumber() -> UInt32{
        return self.imageNumber
    }

}