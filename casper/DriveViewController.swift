//
//  DriveViewController.swift
//  casper
//
//  Created by Marco Koivisto on 2016-02-15.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import UIKit
import SpriteKit
class DriveViewController: UIViewController {
    
    let joystick = AnalogJoystick(diameter: 100)
    @IBOutlet weak var mapBtn: UIBarButtonItem!
    @IBOutlet weak var mapView: UIImageView!
    
    var startPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapBtn.imageInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        let size = CGSizeMake(self.view.bounds.height, self.view.bounds.width)
        let scene = DriveScene(size: size)
        if let skView = view as? SKView {
            
            skView.showsFPS = false
            skView.showsNodeCount = false
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        //LightContent
        return UIStatusBarStyle.LightContent
        
        //Default
        //return UIStatusBarStyle.Default
        
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Landscape
    }
    
    @IBAction func createMapBtn(sender: AnyObject) {
        let mapSize = CGSize(width: mapView.bounds.width, height: mapView.bounds.height)
        let map = drawMap(mapSize)
        mapView.image = map
    }
    func drawMap(size: CGSize) -> UIImage{
        let bounds = CGRect(origin: CGPoint.zero, size: size)
        let opaque = false;
        let scale : CGFloat = 0;
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        // MAP
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextSetLineWidth(context, 2.0)
        CGContextStrokeRect(context, bounds)
        
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, CGRectGetMinX(bounds)+15, CGRectGetMaxX(bounds)+15)
        CGContextAddLineToPoint(context, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))
        CGContextMoveToPoint(context, CGRectGetMaxX(bounds), CGRectGetMinY(bounds))
        CGContextAddLineToPoint(context, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
        CGContextStrokePath(context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
    
}