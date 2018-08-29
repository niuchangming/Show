//
//  ChatManager.swift
//  DouYin
//
//  Created by Niu Changming on 19/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import SendBirdSDK

let ErrorDomainConnection = "com.ekooshow.connection"
let ErrorDomainUser = "com.ekooshow.user"

class ChatManager: NSObject {
    var observers: NSMapTable<NSString, AnyObject> = NSMapTable(keyOptions: .copyIn, valueOptions: .weakMemory)
    
    static let sharedInstance = ChatManager();
    
    override init() {
        super.init()
        SBDMain.add(self as SBDConnectionDelegate, identifier: self.description)
    }
    
    deinit {
        SBDMain.removeConnectionDelegate(forIdentifier: self.description)
    }
    
    static public func login(completionHandler: ((_ user: SBDUser?, _ error: NSError?) -> Void)?) {
        var userId: String? = UserDefaults.standard.string(forKey: "sendbird_user_id")
        var userNickname: String? = UserDefaults.standard.string(forKey: "sendbird_user_nickname")
        
        if !Utils.isNotNil(obj: userId) {
            if(AuthUtils.share.validate() == .LOGGED){
                let userDefault: UserDefaults = UserDefaults.standard
                let userType = userDefault.object(forKey: Constants.Auth.LOGIN_TYPE) as! String
                
                if(userType == Constants.MOBILE_LOGGED){
                    userId = userDefault.object(forKey: Constants.Auth.MOBILE) as? String
                }else if(userType == Constants.FACEBOOK_APP_ID){
                    userId = userDefault.object(forKey: Constants.Auth.FB_USER_ID) as? String
                }else if(userType == Constants.WECHAT_APP_ID){
                    userId = userDefault.object(forKey: Constants.Auth.WX_UNION_ID) as? String
                }else{
                    userId = Utils.generateUniqueCode()
                }
            }else{
                userId = Utils.generateUniqueCode()
            }
        }
        
        if !Utils.isNotNil(obj: userNickname) {
            userNickname = Utils.fakeName()
        }
        self.login(userId: userId!, nickname: userNickname!, completionHandler: completionHandler)
    }
    
    static public func login(userId: String, nickname: String, completionHandler: ((_ user: SBDUser?, _ error: NSError?) -> Void)?) {
        self.sharedInstance.login(userId: userId, nickname: nickname, completionHandler: completionHandler)
    }
    
    private func login(userId: String, nickname: String, completionHandler: ((_ user: SBDUser?, _ error: NSError?) -> Void)?) {
        SBDMain.connect(withUserId: userId) { (user, error) in
            guard error == nil else {
                self.removeUserInfo()
                if let handler = completionHandler {
                    var userInfo: [String: Any]?
                    if let reason: String = error?.localizedFailureReason {
                        userInfo?[NSLocalizedFailureReasonErrorKey] = reason
                    }
                    userInfo?[NSLocalizedDescriptionKey] = error?.localizedDescription
                    userInfo?[NSUnderlyingErrorKey] = error;
                    let connectionError: NSError = NSError.init(domain: ErrorDomainConnection, code: error!.code, userInfo: userInfo)
                    handler(nil, connectionError)
                }
                return;
            }
            
            if let handler = completionHandler {
                handler(user, nil)
            }
        }
    }
    
    private func removeUserInfo() {
        let userDefault: UserDefaults = UserDefaults.standard
        userDefault.removeObject(forKey: "sendbird_user_id")
        userDefault.removeObject(forKey: "sendbird_user_nickname")
        userDefault.synchronize()
    }
    
    static public func logout(completionHandler: (() -> Void)?) {
        self.sharedInstance.logout(completionHandler: completionHandler)
    }
    
    private func logout(completionHandler: (() -> Void)?) {
        SBDMain.disconnect {
            self.removeUserInfo()
            
            if let handler: () -> Void = completionHandler {
                handler()
            }
        }
    }
    
}

extension ChatManager: SBDConnectionDelegate{
    func didStartReconnection() {
        
    }
    
    func didSucceedReconnection() {
        
    }
    
    func didFailReconnection() {
        
    }
    
    func didCancelReconnection() {
        
    }
}














