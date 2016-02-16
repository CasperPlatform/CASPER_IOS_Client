//
//  ViewController.swift
//  casper
//
//  Created by Pontus Pohl on 15/02/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwdField: UITextField!
    
    @IBAction func loginBtn(sender: AnyObject) {
        if(usernameField.text == "admin" && passwdField.text == "Password"){
            performSegueWithIdentifier("login", sender: self)
        }
        print(usernameField.text! + " is logging in")
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwdField.delegate = self
        self.usernameField.delegate = self
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
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}

