//
//  RestUtil.swift
//  casper
//
//  Created by Pontus Pohl on 16/02/16.
//  Copyright © 2016 Pontus Pohl. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RestUtil: NSOperation {
    
    var token:String = ""
    var username:String = ""
    var password:String = ""
    let HOST            = "192.168.10.1"
    let PORT            = "10000"
    let completionHandler : (responseObject:JSON? ,error: NSError?) -> ()
    
    init(username: String, password:String, completionHandler:(responseObject:JSON?,error:NSError?) -> ()){
        self.username = username
        self.password = password
        self.completionHandler = completionHandler
        super.init()
        
      }
    
    override func main() {
        authenticate(username, password: password)
    }
    
    func authenticate(username: String, password:String){
        
        let manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = [
            "content-type": "application/json",
        ]
        let params = [
            "username": username,
            "password": password
        ]
        
        Alamofire.request(.POST, "http://"+HOST+":"+PORT+"/login", parameters: params, encoding: .JSON )
            .responseJSON { response in guard response.result.error == nil
                else
                {
                    self.completionHandler(responseObject: nil, error: response.result.value as? NSError)
                    return
                }
                print("error is nil")
                self.completionHandler(responseObject: JSON((response.result.value)!), error: response.result.value as? NSError)
                
        
        //Alamofire.request(.POST, "http://localhost:3000/login", parameters: params,encoding: .JSON, headers: headers).responseJSON{response in guard response.result.error == nil
          //  else
        //{
            // got an error in getting the data, need to handle it
            //print("error calling GET on /posts/1")
            //print(response.result.error!)
            //return
            //}
            //if let value: AnyObject = response.result.value {
                // handle the results as JSON, without a bunch of nested if loops
              //  let post = JSON(value)
                //print(post)
                //self.token = post["token"].string!
            //}
        }
    }
    
}
