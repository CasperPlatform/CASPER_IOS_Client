//
//  VideoStreamImage.swift
//  casper
//
//  Created by Pontus Pohl on 04/04/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import Foundation
class VideoStreamImage : NSObject {
    
    let packageCount : UInt32 = 0
    var packages = Array<VideoStreamImagePacket>()
    var packageNumber :UInt32
    var bytes         :UInt32
    var imageNumber   :UInt32
    var imageData     :NSMutableData = NSMutableData()
    
    
    override init(){
        self.packageNumber = 0
        self.bytes         = 0
        self.imageNumber   = 0
        super.init()
    }
    init(header: NSData){
       
        self.packageNumber = 0
        self.bytes         = 0
        self.imageNumber   = 0
        super.init()
        processHeader(header)
      
        
    }
    func addPackage(){
        
    }
    func isComplete() -> Bool{
        
        return false
    }
    func processHeader(header : NSData){
        
    }
}