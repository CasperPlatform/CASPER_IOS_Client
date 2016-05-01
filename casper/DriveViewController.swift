//
//  DriveViewController.swift
//  casper
//
//  Created by Marco Koivisto on 2016-02-15.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import UIKit
import SpriteKit
class DriveViewController: UIViewController, VideoStreamDelegate, LidarMapperDelegate {
    

    @IBOutlet weak var videoView: UIImageView!
    @IBOutlet weak var mapZoomBtn: UIButton!
    
    var joystick = AnalogJoystick(diameter: 100)
    var cameraJoystick = AnalogJoystick(diameter: 100)
    @IBOutlet weak var mapBtn: UIBarButtonItem!
    @IBOutlet weak var mapView: UIImageView!
    

    var videoSocket : VideoStream!
    var driveSocket : DriveStream!
    var lidarMapper : LidarMapper!
    var startPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
   
    

    @IBOutlet weak var drive: SKView!
    
    @IBOutlet var background: UIView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapBtn.imageInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        let size = CGSizeMake(self.view.bounds.height, self.view.bounds.width)
        let scene = DriveScene(size: size)
        joystick = scene.moveAnalogStick
        cameraJoystick = scene.moveAnalogStick2
        background.backgroundColor = UIColor(white: 0.5, alpha: 1.0)
        
        // start streaming video
        if(startDriveStream() && startVideoStream()){
            // do post-init stuff
            print("All Streams ok")
        }
        else{
            
            displayFailedMsg()
        }
        
        
        if let skView = drive as? SKView {
            skView.showsFPS = false
            skView.showsNodeCount = false
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .AspectFill
            skView.allowsTransparency = true;
            skView.backgroundColor = UIColor(white: 0.0, alpha: 0.0);
            skView.presentScene(scene)
            
        }
        
        
        
       
        
        
        //
        //        var timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("updateJoystickCoordinates:"), userInfo: nil, repeats: true)
        
//        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: SocketConn!, selector: Selector("sendValue:"), userInfo: joystick, repeats: true)
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        print("view disappeared")
        stopServices()
    }
    func stopServices(){
        //        self.SocketConn!.closeStream()
        if( self.videoSocket != nil ) {
            self.videoSocket.closeStream()
            self.videoSocket = nil
        }
        if( self.driveSocket != nil ) {
            self.driveSocket.closeStream()
            self.driveSocket = nil
        }
        if( self.drive != nil ){
            self.joystick.removeAllActions()
            self.cameraJoystick.removeAllActions()
            self.drive = nil
        }
        
        
       
    }
    func displayFailedMsg(){
        let alertController = UIAlertController(title: "Stream error", message: "Your login credentials seem to be invalid, logging you out.", preferredStyle: .Alert)
        
        
        
        let okAction = UIAlertAction(title: "ok", style: .Default) { (action) -> Void in
            print("The user is logged out")
            self.logout()
        }
        
        
        alertController.addAction(okAction)
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true, completion: nil)
        })

    }
    func startVideoStream() -> Bool{
        // Instantiate and send Start command to videostream.
        self.videoSocket = VideoStream(delegate: self)
        return self.videoSocket.setupConnection()
            
        
    }
    func startDriveStream() -> Bool{
        
        self.driveSocket = DriveStream(joystick: joystick)
        return self.driveSocket.setupConnection()
        
    }
    func logout(){
        performSegueWithIdentifier("toLoginScreen", sender: self)
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
    
    
    //.animateWithDuration(0.7, delay: 1.0, options: .CurveEaseOut, animations: {
    
    @IBAction func mapZoomBtn(sender: AnyObject) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
        if self.mapView.frame.width != self.view.bounds.width && self.mapView.frame.height != self.view.bounds.height {
            self.mapView.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
            self.mapZoomBtn.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
            
        }
        else{
            self.mapView.frame = CGRectMake((self.view.bounds.width/2)-132, self.view.bounds.height-(146+50), 264, 146)
            self.mapZoomBtn.frame = CGRectMake((self.view.bounds.width/2)-132, self.view.bounds.height-(146+50), 264, 146)
        }
        }, completion: nil)
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
    func DidReceiveImage(sender: VideoStream, image: NSData) {
        print("image received")
        
            self.videoView.image = UIImage(data: image)!
    }
    func DidReceiveMap(sender: VideoStream, image: NSData) {
        print("received new map")
    }
}