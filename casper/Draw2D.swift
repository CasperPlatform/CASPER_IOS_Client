//
//  Draw2D.swift
//  casper
//
//  Created by Pontus Pohl on 24/04/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import UIKit

class Draw2D: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 4.0)
        CGContextSetStrokeColorWithColor(context,
                                         UIColor.lightGrayColor().CGColor)
        let rectangle = CGRectMake(20,20,300,150)
        CGContextAddRect(context, rectangle)
        CGContextStrokePath(context)
        // Drawing code
    }
 

}
