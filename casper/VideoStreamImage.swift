//
//  VideoStreamImage.swift
//  casper
//
//  Created by Pontus Pohl on 04/04/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import Foundation
class VideoStreamImage : NSObject {
    
 
    var header       : NSData
    var packageCount : UInt8 = 0
    var packages = Array<VideoStreamImagePacket>()
    var packageNumber :UInt32
    var byteCount         :UInt32
    var imageNumber   :UInt32
    var imageData     :NSMutableData = NSMutableData()
    var isComplete    : Bool
    
    weak var delegate:VideoStreamImageDelegate?
    
    override init(){
        self.packageNumber   = 0
        self.byteCount       = 0
        self.imageNumber     = 0
        self.header          = NSData()
        self.isComplete = false
        
        super.init()
    }
    init(header: Array<UInt8>, delegate: VideoStreamImageDelegate){
       
        self.packageNumber = 0
        self.byteCount     = 0
        self.imageNumber   = 0
        self.isComplete    = false
        self.delegate = delegate
        self.header        = NSData(bytes: header, length: header.count)
        super.init()
        processHeader(header)
    }
    init(imageNr:UInt32, delegate: VideoStreamImageDelegate){
        self.packageNumber = 0
        self.byteCount     = 0
        self.imageNumber   = imageNr
        self.isComplete    = false
        self.header        = NSData()
        super.init()
    }
    func addPackage(package: VideoStreamImagePacket){
        
        if(self.header.length == 0 && self.imageNumber == package.getImageNumber() ){
            packages.append(package)
            
            return
        }
        
        
        if(package.getImageNumber() == self.imageNumber){
//            print("adding package at index")
            packages[Int(package.packetNumber)] = package
//            print(packages.count)
//            print(package.packetNumber)
        }
        if(self.packages.count == Int(self.packageCount) && self.header.length != 0){
            var hasAll = true
            for packet in packages{
                if( packet.getPacketData().length == 0){
                    hasAll = false
                }
            }
            if(hasAll){
                print("marking as complete")
                self.isComplete = true
                delegate?.DidCompleteImage(self, image: imageData)
            }
        }
    }
    func addHeader(header: Array<UInt8>){
       
        self.header = NSData(bytes: header, length: header.count)
        processHeader(header)
        print("number of packages it should be:", self.packageCount," Number in array:", self.packages.count)
        if(self.packages.count == Int(self.packageCount) && self.header.length != 0){
            var hasAll = true
            for packet in packages{
                if( packet.getPacketData().length == 0){
                    hasAll = false
                }
            }
            if(hasAll){
                self.isComplete = true
                self.delegate?.DidCompleteImage(self, image: imageData)
            }
            
        }
    }
    func isCompleteImage() -> Bool{
        return isComplete
    }
    func processHeader(header : Array<UInt8>){
//        let count = header.length / sizeof(UInt8)
//        // create array of appropriate length:
//        var byteArray = [UInt8](count: count, repeatedValue: 0)
//        // copy bytes into array
//        header.getBytes(&byteArray, length:count * sizeof(UInt8))
//        print(byteArray[0])
        
        var imageNr, byteCount : UInt32
        // the number of elements:
        
        var imageNrArr =   [UInt8](count: 4, repeatedValue: 0)
        var byteCountArr = [UInt8](count: 4, repeatedValue: 0)
        
        imageNrArr        = Array(header[2..<6])
        byteCountArr      = Array(header[7..<11])
        self.imageNumber  = getNumberFromBytes(imageNrArr)
        self.byteCount    = getNumberFromBytes(byteCountArr)
        self.packageCount = header[6]
        // check if image was created from packages from before
        if(self.packages.count != 0)
        {
            var tmp = Array<VideoStreamImagePacket>(count: Int(self.packageCount), repeatedValue: VideoStreamImagePacket())
            for packet in self.packages {
                tmp[Int(packet.getPacketNumber())] = packet
            }
            self.packages = Array(tmp)
        }
        else{
           self.packages = Array<VideoStreamImagePacket>(count: Int(self.packageCount), repeatedValue: VideoStreamImagePacket())
        }
        
        
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
    func getImageData() -> NSData{
     
//        print("crunching image data")
//        print("packages count is: ",packages.count)
        
        for package in packages{
            self.imageData.appendData(package.packetData)
        }
        
//        for var index:Int = 0 ; index < packages.count ;index += 1 {
//            print(packages[index].getPacketData().length)
//            if(Int(packages[index].packetNumber) == count){
//                self.imageData.appendData(packages[index].getPacketData())
//                count+=1
//                index=1
//            }
//        }
  
       
        
        return self.imageData
       
        
    }

}