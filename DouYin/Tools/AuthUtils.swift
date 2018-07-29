//
//  AuthUtils.swift
//  DouYin
//
//  Created by Niu Changming on 11/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

enum AuthType {
    case LOGGED
    case EXPIRED
    case UNAUTH
}

class AuthUtils: NSObject {
    
    static let share : AuthUtils = {
        let manager = AuthUtils()
        return manager
    }()

    
    func validate() -> AuthType {
        var type: AuthType = .UNAUTH
        let isLogin = UserDefaults.standard.bool(forKey: Constants.Auth.LOGGED_IN)

        if(isLogin){
            type = .LOGGED
            
            let loginType = UserDefaults.standard.object(forKey: Constants.Auth.LOGIN_TYPE) as! String
            if loginType == Constants.FACEBOOK_LOGGED || loginType == Constants.WECHAT_LOGGED {
                let expiredDate = UserDefaults.standard.object(forKey: Constants.Auth.FB_TOKEN_EXPIRED) as! Date
                if Date() >= expiredDate {
                    type = .EXPIRED
                }
            }
        }
    
        return type
    }
    
    func saveFacebookInfo(result: FBSDKLoginManagerLoginResult, apiToken: String){
        saveLoginInfo(countryCode: nil, mobile: nil, apiToken: apiToken)
        
        let defaults = UserDefaults.standard
        defaults.set(result.token.tokenString, forKey: Constants.Auth.FB_ACCESS_TOKEN)
        defaults.set(result.token.expirationDate, forKey: Constants.Auth.FB_TOKEN_EXPIRED)
        defaults.set(Constants.FACEBOOK_LOGGED, forKey: Constants.Auth.LOGIN_TYPE)
        defaults.set(result.token.userID, forKey: Constants.Auth.FB_USER_ID)
        defaults.synchronize()
    }
    
    func saveWechatInfo(result: WXAuth, apiToken: String){
        saveLoginInfo(countryCode: nil, mobile: nil, apiToken: apiToken)
        
        let defaults = UserDefaults.standard
        defaults.set(result.expiredIn, forKey: Constants.Auth.WX_TOKEN_EXPIRED)
        defaults.set(result.accessToken, forKey: Constants.Auth.WX_ACCESS_TOKEN)
        defaults.set(Constants.WECHAT_LOGGED, forKey: Constants.Auth.LOGIN_TYPE)
        defaults.set(result.unionId, forKey: Constants.Auth.WX_UNION_ID)
        defaults.synchronize()
    }
    
    func saveLoginInfo(countryCode: String?, mobile: String?, apiToken: String){
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: Constants.Auth.LOGGED_IN)
        defaults.set(apiToken, forKey: Constants.Auth.API_TOKEN)
        
        if(!Utils.isNotNil(obj: defaults.object(forKey: Constants.Auth.LOGIN_TYPE))){
            defaults.set(Constants.MOBILE_LOGGED, forKey: Constants.Auth.LOGIN_TYPE)
            defaults.set(String(format: "%@%@", countryCode!, mobile!), forKey: Constants.Auth.MOBILE)
        }
        
        defaults.synchronize()
    }
    
    func apiToken() -> String{
        return UserDefaults.standard.object(forKey: Constants.Auth.API_TOKEN) as! String
    }

}




























