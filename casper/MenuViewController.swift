//
//  MenuViewController.swift
//  casper
//
//  Created by Marco Koivisto on 2016-02-15.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var token:String = ""
    
   
    @IBOutlet weak var settings: UIBarButtonItem!
    
    
    @IBAction func socketAction(sender: AnyObject) {
      
//        connection.Open()
        //connection.openStreamAndSendValues(0x56,0x45,speed:0x55, direction: 0x76)
      
        
        
        
        //var readByte :UInt8 = 0
        //while inputStream.hasBytesAvailable {
          //  inputStream.read(&readByte, maxLength: 1)
       // }
        
        // buffer is a UInt8 array containing bytes of the string "Jonathan Yaniv.".
        //outputStream.write(&buffer, maxLength: buffer.count)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings.imageInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        print(userDefaults.objectForKey("token") as? NSString )
        
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
        return .Portrait
    }
    
}