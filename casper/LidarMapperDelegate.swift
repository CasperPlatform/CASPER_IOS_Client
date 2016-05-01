//
//  LidarMapperDelegate.swift
//  casper
//
//  Created by Pontus Pohl on 24/04/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import Foundation
protocol LidarMapperDelegate: class {
    func DidReceiveMap(sender: VideoStream, image: NSData)
}