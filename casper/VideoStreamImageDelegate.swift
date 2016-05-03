//
//  VideoStreamImageDelegate.swift
//  casper
//
//  Created by Pontus Pohl on 04/04/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import Foundation
protocol VideoStreamImageDelegate: class {
    func DidCompleteImage(sender: VideoStreamImage, image: NSData)
}