//
//  SettingsController.swift
//  casper
//
//  Created by Marco Koivisto on 2016-02-15.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import UIKit
class SettingsViewController: UIViewController, VideoStreamDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var video : VideoStream!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        video = VideoStream(delegate: self)
     
        
        
        
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
    func DidReceiveImage(sender: VideoStream, image: NSData) {
        print("image received")
        self.imageView.image = nil
        self.imageView.image = UIImage(data: image)!
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
}