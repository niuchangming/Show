//
//  WXAuth.swift
//  DouYin
//
//  Created by Niu Changming on 12/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import HandyJSON
import Alamofire

class WXAuth: HandyJSON {
    var accessToken: String = ""
    var openId: String = ""
    var refreshToken: String = ""
    var unionId: String = ""
    var scope: String = ""
    var expiredIn: CLong = 0
    var code: String = ""
    
    required init() {}
    
    required init(code: String) {
        self.code = code
    }
    
    func getData(message:@escaping (String) -> ()) {
        let wxApi = "https://api.weixin.qq.com/sns/oauth2/access_token"
        let params = ["appid": Constants.WECHAT_APP_ID, "secret": Constants.WECHAT_SECRET, "code": code, "grant_tyoe": "authorization_code"]
        ConnectionManager.shareManager.request(method: .post, url: wxApi, parames: params as [String : AnyObject], succeed: { [unowned self] (responseJson) in
            
            let model = WXAuth.deserialize(from: responseJson as? NSDictionary)
            self.accessToken = (model?.accessToken)!
            self.openId = (model?.openId)!
            self.refreshToken = (model?.refreshToken)!
            self.unionId = (model?.unionId)!
            self.scope = (model?.scope)!
            self.expiredIn = (model?.expiredIn)!
            
            message("Success")
            
        }) { (error) in
            message("Fail")
        }
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.accessToken <-- "access_token"
    
        mapper <<<
            self.accessToken <-- "expires_in"
        
        mapper <<<
            self.openId <-- "openid"
        
        mapper <<<
            self.refreshToken <-- "refresh_token"
        
        mapper <<<
            self.unionId <-- "unionid"
    }
}
