//
//  ViewController.swift
//  casper
//
//  Created by Pontus Pohl on 15/02/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwdField: UITextField!
    
    @IBAction func loginBtn(sender: AnyObject) {
        
        print(usernameField.text! + "is logging in")
        
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

