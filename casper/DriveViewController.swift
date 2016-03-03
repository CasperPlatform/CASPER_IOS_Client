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
    
    var joystick = AnalogJoystick(diameter: 100)
    @IBOutlet weak var mapBtn: UIBarButtonItem!
    @IBOutlet weak var mapView: UIImageView!
    var SocketConn:SocketConnection?
    var startPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapBtn.imageInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        let size = CGSizeMake(self.view.bounds.height, self.view.bounds.width)
        let scene = DriveScene(size: size)
        joystick = scene.moveAnalogStick
        if let skView = view as? SKView {
            
            skView.showsFPS = false
            skView.showsNodeCount = false
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
        
        self.SocketConn = SocketConnection()
        
        // Do any additional setup after loading the view, typically from a nib.
        let mapSize = CGSize(width: mapView.bounds.width, height: mapView.bounds.height)
        /*let map = drawMap(mapSize)
        mapView.image = map*/
        
        
//        
//        var timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("updateJoystickCoordinates:"), userInfo: nil, repeats: true)
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: SocketConn!, selector: Selector("sendValue:"), userInfo: joystick, repeats: true)
        
    }
    
    deinit {
        print("deIniting")
        // perform the deinitialization
    }
    
    override func viewDidDisappear(animated: Bool) {
        print("view disappeared")
        self.SocketConn!.closeStream()
        self.timer.invalidate()
      
       
        
       
        
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
    
    func updateJoystickCoordinates(timer:NSTimer){
        
        
        var x = (joystick.stick.position.x / 40) * 90
        var y = (joystick.stick.position.y / 40) * 255
        var fx = 0x52
        var fy = 0x46
        if( y < 0) {
            fy = 0x42
            y = y * -1
        }
        if( x < 0){
            fx = 0x4c
            x = x * -1
        }
        
        
        
        let angle = UInt8(x)
        let speed = UInt8(y)
        let flagDirectionY = UInt8(fy)
        let flagDirectionX = UInt8(fx)
        print(angle)
        print(speed)
        
        SocketConn!.angle = angle
        SocketConn!.speed = speed
        SocketConn!.flagx = flagDirectionX
        SocketConn!.flagy = flagDirectionY
        
        
        
        
        
        
        
//        
//        SocketConn.openStreamAndSendValues(flagDirectionX, flagY: flagDirectionY, speed: speed, direction: angle)
    }
    
    /*func drawMap(size: CGSize) -> UIImage{
        let bounds = CGRect(origin: CGPoint.zero, size: size)
        let opaque = false;
        let scale : CGFloat = 0;
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        // MAP
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextSetLineWidth(context, 2.0)
        CGContextStrokeRect(context, bounds)
        
        return UIImage;
        
    }*/
    
}