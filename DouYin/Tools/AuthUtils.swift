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
    
    static let shareManager : AuthUtils = {
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
    
    func saveFacebookInfo(result: FBSDKLoginManagerLoginResult){
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: Constants.Auth.LOGGED_IN)
        defaults.set(result.token.tokenString, forKey: Constants.Auth.FB_ACCESS_TOKEN)
        defaults.set(result.token.expirationDate, forKey: Constants.Auth.FB_TOKEN_EXPIRED)
        defaults.set(Constants.FACEBOOK_LOGGED, forKey: Constants.Auth.LOGIN_TYPE)
        defaults.synchronize()
    }
    
    func saveWechatInfo(result: WXAuth){
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: Constants.Auth.LOGGED_IN)
        defaults.set(result.expiredIn, forKey: Constants.Auth.WX_TOKEN_EXPIRED)
        defaults.set(result.accessToken, forKey: Constants.Auth.WX_ACCESS_TOKEN)
        defaults.set(Constants.WECHAT_LOGGED, forKey: Constants.Auth.LOGIN_TYPE)
        defaults.synchronize()
    }

}



























