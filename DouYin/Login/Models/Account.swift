//
//  Account.swift
//  DouYin
//
//  Created by Niu Changming on 3/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import HandyJSON
import FBSDKLoginKit
import FBSDKCoreKit

class Account: HandyJSON {
    
    var token : String = ""
    var userCode : String = ""
    var type : String = ""
    var countryCode: String = ""
    var mobile: String = ""
    var roleType: Int = 0
    
    required init() {}
    
    func mobileLogin(countryCode: String, mobile: String, password: String, completed:@escaping (_ account: Account?, _ message: String) -> ()) {
        
        let loginAPI = String(format: "%@user/login", Constants.HOST)
        
        ConnectionManager.shareManager.request(method: .post, url: loginAPI, parames: ["countryCode":countryCode, "mobile": mobile, "password":password, "type": "mobile"] as [String : AnyObject], succeed: { (responseJson) in
            
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            let message = response["message"] as! String
            if errorCode == 1 {
                let data = response["data"] as! NSDictionary
                let accountModel = Account.deserialize(from: data)
                completed(accountModel!, message)
            }else{
                completed(nil, message)
            }
            
        }) { (error) in
           completed(nil, "HTTP Connection Failed")
        }
    }
    
    func mobileSignup(countryCode: String, mobile: String, password: String, completed:@escaping (_ account: Account?, _ message: String) -> ()){
        let signupAPI = String(format: "%@user/signup", Constants.HOST)
        
        ConnectionManager.shareManager.request(method: .post, url: signupAPI, parames: ["mobile": mobile, "password": password, "countryCode": "65", "type": "mobile"] as [String : AnyObject], succeed: { (responseJson) in
            
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            let message = response["message"] as! String
            if errorCode == 1 {
                let accountModel = Account.deserialize(from: response)
                accountModel?.type = "mobile"
                accountModel?.mobile = mobile
                accountModel?.countryCode = countryCode
                completed(accountModel!, message)
            }else{
                completed(nil, message)
            }
        
            }, failure: { (error) in
                completed(nil, "HTTP Connection Failed")
        })
    }
    
    func verify2FACode(apiToken: String, verifyCode: String, completed: @escaping (_ account: Account?, _ message: String) -> () ) {
        let verifyAPI = String(format: "%@user/2fa", Constants.HOST)
        ConnectionManager.shareManager.request(method: .post, url: verifyAPI, parames: ["verifyCode":verifyCode as NSString, "token": apiToken as NSString], succeed: { (responseJson) in
            
                let response = responseJson as! NSDictionary
                let errorCode = response["errorCode"] as! Int
                let message = response["message"] as! String
                if errorCode == 1 {
                    let data = response["data"] as! NSDictionary
                    let accountModel = Account.deserialize(from: data)
                    completed(accountModel!, message)
                }else{
                    completed(nil, message)
            }
            
            }, failure: { (error) in
                completed(nil, "HTTP Connection Failed")
            })
    }
    
    
    func facebookLogin(fbResult: FBSDKLoginManagerLoginResult, completed: @escaping (_ account: Account?, _ message: String) -> () ) {
        let expriedDateInMills = String(format: "%i", fbResult.token.expirationDate.toMillis())
        let loginAPI = String(format: "%@user/login", Constants.HOST)
        
        ConnectionManager.shareManager.request(method: .post, url: loginAPI, parames: ["type": "facebook" as NSString, "fb_token": fbResult.token.tokenString as NSString, "expired": expriedDateInMills as NSString, "fb_id": fbResult.token.userID as NSString], succeed: { (responseJson) in
            
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            let message = response["message"] as! String
            if errorCode == 1 {
                let data = response["data"] as! NSDictionary
                let accountModel = Account.deserialize(from: data)
                completed(accountModel, message)
            }else{
                completed(nil, message)
            }
            
        }, failure: { (error) in
            completed(nil, "HTTP Connection Failed")
        })
    }

}















