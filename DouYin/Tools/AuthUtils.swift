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
    
    func saveFacebookInfo(result: FBSDKLoginManagerLoginResult, account: Account){
        saveLoginInfo(account: account)

        let defaults = UserDefaults.standard
        defaults.set(result.token.tokenString, forKey: Constants.Auth.FB_ACCESS_TOKEN)
        defaults.set(result.token.expirationDate, forKey: Constants.Auth.FB_TOKEN_EXPIRED)
        defaults.set(Constants.FACEBOOK_LOGGED, forKey: Constants.Auth.LOGIN_TYPE)
        defaults.set(result.token.userID, forKey: Constants.Auth.FB_USER_ID)
        defaults.synchronize()
    }
    
    func saveWechatInfo(result: WXAuth, account: Account){
        saveLoginInfo(account: account)

        let defaults = UserDefaults.standard
        defaults.set(result.expiredIn, forKey: Constants.Auth.WX_TOKEN_EXPIRED)
        defaults.set(result.accessToken, forKey: Constants.Auth.WX_ACCESS_TOKEN)
        defaults.set(Constants.WECHAT_LOGGED, forKey: Constants.Auth.LOGIN_TYPE)
        defaults.set(result.unionId, forKey: Constants.Auth.WX_UNION_ID)
        defaults.synchronize()
    }
    
    func saveLoginInfo(account: Account){
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: Constants.Auth.LOGGED_IN)
        defaults.set(account.token, forKey: Constants.Auth.API_TOKEN)
        defaults.set(account.userCode, forKey: Constants.Auth.USER_CODE)
        defaults.set(account.roleType, forKey: Constants.Auth.ROLE)
        
        if(!Utils.isNotNil(obj: defaults.object(forKey: Constants.Auth.LOGIN_TYPE))){
            defaults.set(Constants.MOBILE_LOGGED, forKey: Constants.Auth.LOGIN_TYPE)
            defaults.set(String(format: "%@%@", account.countryCode, account.mobile), forKey: Constants.Auth.MOBILE)
        }
        
        defaults.synchronize()
    }
    
    func saveChannelId(channelId: String){
        let defaults = UserDefaults.standard
        defaults.set(channelId, forKey: Constants.Auth.CHANNEL_ID)
        defaults.synchronize()
    }
    
    func apiToken() -> String? {
        return UserDefaults.standard.object(forKey: Constants.Auth.API_TOKEN) as? String
    }
    
    func userCode() -> String? {
        return UserDefaults.standard.object(forKey: Constants.Auth.USER_CODE) as? String
    }
    
    func isAnchor() -> Bool{
        return UserDefaults.standard.object(forKey: Constants.Auth.ROLE) != nil && UserDefaults.standard.object(forKey: Constants.Auth.ROLE) as! Int == 2
    }
    
    func channelId() -> String? {
        let channelId = UserDefaults.standard.object(forKey: Constants.Auth.CHANNEL_ID)
        return channelId as? String
    }
    
    func setRoleAsAnchor() {
        let defaults = UserDefaults.standard
        defaults.set(2, forKey: Constants.Auth.ROLE)
        defaults.synchronize()
    }

}




























