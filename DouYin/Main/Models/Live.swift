//
//  Live.swift
//  DouYin
//
//  Created by Niu Changming on 27/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class NDLiveData: NSObject {
    
    var lives = [livess]()
    
    func getHotLivDatas(message:@escaping (String?) -> ()) {
        let kTJPHotLiveAPI = "http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1"
        ConnectionManager.shareManager.request(Type: HttpType.Get, url: kTJPHotLiveAPI, parames: ["":""] as [String : AnyObject], succeed: { (succes, responsObject) in
            
            let model = NDLiveData.model(withJSON: responsObject as AnyObject)
            self.lives = (model?.lives)!
            
            message("Success")
            
        }) { (failer) in
            message("Fail")
        }
    }
    
    static func modelContainerPropertyGenericClass() -> [String : AnyObject]? {
        return ["lives": livess.self]
    }
    
}

class livess: NSObject {
    var city : String = ""
    var id : String = ""
    var name : String = ""
    var room_id : String = ""
    var distance : String = ""
    var cellHeight : CGFloat = 300

    public var stream_addr = String() {
        didSet {
            if !stream_addr.hasPrefix("http") {
                self.stream_addr = "http://img2.inke.cn/" + self.stream_addr
            }
        }
    }

    public var share_addr = String() {
        didSet {
            if !share_addr.hasPrefix("http") {
                self.share_addr = "http://img2.inke.cn/" + self.share_addr
            }
        }
    }

    var creator : creators?
    var extra : extras?
    
    static func modelContainerPropertyGenericClass() -> [String : AnyObject]? {
        return ["creator": creators.self, "extra": extras.self]
    }
}

class creators: NSObject {
    var id : String = ""
    var level : String = ""
    var gender : String = ""
    var nick : String = ""
    
    public var portrait = String() {
        didSet {
            if !portrait.hasPrefix("http") {
                self.portrait = "http://img.meelive.cn/" + self.portrait
            }
        }
    }
}

class extras: NSObject {
    
    var label = [labelst]()
    
    static func modelContainerPropertyGenericClass() -> [String : AnyObject]? {
        return ["label"    : labelst.self]
    }
}

class labelst: NSObject {
    var tab_name : String = ""
    var tab_key : String = ""
}
