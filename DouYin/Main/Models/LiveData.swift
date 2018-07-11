//
//  Broadcast.swift
//  DouYin
//
//  Created by Niu Changming on 26/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import Foundation
import Alamofire
import HandyJSON

class LiveData: HandyJSON{
    var flow = [Live]()
    
    required init() {}
    
    func getData(message:@escaping (String) -> ()) {
        
        let liveAPI = "http://116.211.167.106/api/live/near_flow_old?&gender=1&gps_info=116.449411%2C39.904484&loc_info=CN%2C%E5%8C%97%E4%BA%AC%E5%B8%82%2C%E5%8C%97%E4%BA%AC%E5%B8%82&is_new_user=1&lc=0000000000000049&cc=TG0001&cv=IK4.0.00_Iphone&proto=7&idfa=2D707AF8-980F-415C-B443-6FED3E9BBE97&idfv=723152C7-9C98-43F8-947F-18331280D72F&devi=135ede19e251cd6512eb6ad4f418fbbde03c9266&osversion=ios_10.100000&ua=iPhone5_2&imei=&imsi=&uid=392716022&sid=20f7ZyQ3C09I3wDcU0i0bM5n3F8osSAui2L04fGf4WTHRgL9J8qi1&conn=wifi&mtid=87edd7144bd658132ae544d7c9a0eba8&mtxid=acbc329027f3&logid=133&interest=0&longitude=116.449411&latitude=39.904484&multiaddr=1&s_sg=dba9d2e16943a8d4568e8bc0f32e6f7d&s_sc=100&s_st=1488507776"
        
        ConnectionManager.shareManager.request(Type: ConnectionType.Post, url: liveAPI, parames: ["":""] as [String : AnyObject], succeed: { [unowned self] (succes, responseJson) in
            
            let model = LiveData.deserialize(from: responseJson as? NSDictionary)
            self.flow = (model?.flow)!
            
            message("Success")
            
        }) { (failer) in
            message("Fail")
        }
    }
}

class Live: HandyJSON {
    var info : Info?
    var flow_type : String = ""
    
    required init(){}
}

class Info: HandyJSON {
    var city : String = ""
    var id : String = ""
    var name : String = ""
    var room_id : String = ""
    var distance : String = ""
    var creator : Creator?
    
    public var stream_addr = String() {
        didSet {
            if !stream_addr.hasPrefix("http") {
                self.stream_addr = "http://img2.inke.cn/" + self.stream_addr
            }
        }
    }
    
    required init(){}
}

class Creator: HandyJSON{
    var birth: String = ""
    var description: String = ""
    var gender: Int = 0
    var hometown: String = ""
    var nick: String = ""
    
    public var portrait = String() {
        didSet {
            if !portrait.hasPrefix("http") {
                self.portrait = "http://img.meelive.cn/" + self.portrait
            }
        }
    }
    
    required init(){}

}











