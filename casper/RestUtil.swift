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

class RestUtil: NSObject {
    
    var token:String = ""
    var username:String = ""
    
    
    init(username: String, password:String){
        super.init()
        self.username = username
        authenticate(username, password: password)
      }
    
    func authenticate(username: String, password:String){
        
        let headers = [
            "content-type": "application/json",
        ]
        let params = [
            "username": username,
            "password": password
        ]
        
        Alamofire.request(.POST, "http://localhost:3000/login", parameters: params,encoding: .JSON, headers: headers).responseJSON{response in guard response.result.error == nil
            else
        {
            // got an error in getting the data, need to handle it
            print("error calling GET on /posts/1")
            print(response.result.error!)
            return
            }
            if let value: AnyObject = response.result.value {
                // handle the results as JSON, without a bunch of nested if loops
                let post = JSON(value)
                print(post)
                //self.token = post["token"].string!
            }
        }
    }
    
}
