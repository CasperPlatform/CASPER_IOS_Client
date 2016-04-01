//
//  VideoStreamDelegate.swift
//  casper
//
//  Created by Pontus Pohl on 01/04/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import Foundation
protocol VideoStreamDelegate: class {
    func DidReceiveImage(sender: VideoStream, image: NSData)
}