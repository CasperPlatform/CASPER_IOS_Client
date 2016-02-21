//
//  MenuViewController.swift
//  casper
//
//  Created by Marco Koivisto on 2016-02-15.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import UIKit
import SocketIOClientSwift
class MenuViewController: UIViewController {
    
    var token:String = ""
    let connection:SocketConnection = SocketConnection()
   
    
    
    @IBAction func socketAction(sender: AnyObject) {
      
        connection.Connect()
        
      
        
        
        
        //var readByte :UInt8 = 0
        //while inputStream.hasBytesAvailable {
          //  inputStream.read(&readByte, maxLength: 1)
       // }
        
        // buffer is a UInt8 array containing bytes of the string "Jonathan Yaniv.".
        //outputStream.write(&buffer, maxLength: buffer.count)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
}