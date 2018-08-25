//
//  Moment.swift
//  DouYin
//
//  Created by Niu Changming on 7/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import HandyJSON

class MomentData: HandyJSON {
    var data = [Moment]()
    var requiredTime = Date()
    var pageIndex: Int = 0
    var pageSize: Int = 20
    var isFinished: Bool = false
    
    required init() {}
    
    func getData(completed :@escaping (Status) -> ()) {
        if isFinished {
            return
        }
        
        ConnectionManager.shareManager.request(method: .post, url: String(format: "%@moment/momentlist", Constants.HOST), parames: ["expires": NSNumber.init(value: requiredTime.toMillis()), "pageIndex": NSNumber.init(value: pageIndex), "pageSize": NSNumber.init(value: pageSize)], succeed: { (responseJson) in
            
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            if errorCode == 1 {
                let model = MomentData.deserialize(from: responseJson as? NSDictionary)
                
                if (model?.data.count)! < 20 {
                    self.data = self.data + (model?.data)!
                    self.isFinished = true
                }else{
                    self.data = self.data + (model?.data)!
                    self.pageIndex = self.pageIndex + 1
                }
                completed(.success)
            }else{
                completed(.failure)
            }
        }) { (error) in
            completed(.failure)
        }
    }
}

class Moment: HandyJSON{
    var momentId: String = ""
    var body: String = ""
    var lon: Double = 0
    var lat: Double = 0
    var comments: [Comment]?
    var creator: Creator?
    var likeCount: Int = 0
    var type: String = "";
    var images: [Photo]?
    
    required init() {}
}

class Creator: HandyJSON{
    var name : String = ""
    var userCode : String = ""
    var title : String = ""
    var userAvatar: Photo?
    
    required init() {}
}

class Comment: HandyJSON{
    var author: String = ""
    var content: String = ""
    
    required init() {}
}

class Link: HandyJSON{
    var link : String = ""
    var icon : String = ""
    var title : String = ""
    
    required init() {}
}















