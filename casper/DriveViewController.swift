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
    @IBOutlet weak var mapView: UIView!
    
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
            view.bringSubviewToFront(mapView)
            view.insertSubview(mapView, aboveSubview: view)
        }
        // Do any additional setup after loading the view, typically from a nib.
        view.bringSubviewToFront(mapView)
        drawLine(CGPoint.init(x: 20, y: 50), toPoint: CGPoint.init(x: 500, y: 50))
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
    func drawLine(fromPoint: CGPoint, toPoint: CGPoint){

    }
    
}