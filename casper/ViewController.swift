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
import SocketIOClientSwift


class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var credentialError: UILabel!
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwdField: UITextField!
    
    var backgroundQueue : NSOperationQueue = NSOperationQueue()
    
    var token:String = ""
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBAction func loginBtn(sender: AnyObject)
    {
        progressIndicator.startAnimating()
        
        if(usernameField.text == "admin" && passwdField.text == "Password"){
            self.userDefaults.setObject("test", forKey: "token")
            performSegueWithIdentifier("login", sender: self)
        }
        else
        {
        
        print(usernameField.text! + " is logging in")
        
        let auth = RestUtil(username: usernameField.text!,
            password: passwdField.text!)
            { (responseObject, error) in
                if(error == nil && responseObject == nil)
                {
                    
                    self.credentialError.text = "Connection failed, probably..."
                }
                else if(error != nil && responseObject == nil)
                {
                    print(error)
                    self.credentialError.text = "Wrong credentials"
                }
                else
                {
                    print(responseObject)
                    if(responseObject!["token"] != "" && responseObject!["token"] != nil )
                    {
                            print("got token")
                            self.token = responseObject!["token"].string!
                            self.userDefaults.setObject(self.token, forKey: "token")
                    }
                    else{
                        self.credentialError.text = "Wrong credentials"
                    }
                }
                
             self.workDone()
            }
    
    
        auth.completionBlock =
            {
                print("done")
      
            }
        auth.queuePriority = .High
        auth.qualityOfService = .UserInteractive
        backgroundQueue.addOperation(auth)
        
        
        }
    }
   
    
    func workDone(){
        progressIndicator.stopAnimating()
        if(self.token as String != ""){
            
            performSegueWithIdentifier("login", sender: self)
        }
    }
    
        //let util : RestUtil = RestUtil(username: usernameField.text!, password: passwdField.text!)
        //if util.token != "" {
          //  print("authenticated")
            //print(util.token)
        //}
        //else{
          //  print("failed to authenticate")
        //}
        
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwdField.delegate = self
        self.usernameField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
       
        
        
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "login"){
            let menuViewController = (segue.destinationViewController as! MenuViewController)
            menuViewController.token = token
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}

