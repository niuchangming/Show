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
    var pageIndex: Int = 0
    var pageSize: Int = 20
    var isFinished: Bool = false
    var timestamp = Date()
    
    required init() {}
    
    func getData(completed :@escaping (Status) -> ()) {
        if isFinished {
            return
        }
        
        ConnectionManager.shareManager.request(method: .post, url: String(format: "%@moment/listall", Constants.HOST), parames: ["timestamp": NSNumber.init(value: timestamp.toMillis()), "pageIndex": NSNumber.init(value: pageIndex), "pageSize": NSNumber.init(value: pageSize), "token": AuthUtils.share.apiToken() as AnyObject], succeed: { (responseJson) in
            
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            if errorCode == 1 {
                let model = MomentData.deserialize(from: responseJson as? NSDictionary)
                
                guard let md = model else { return }
                
                let sortData = md.data.sorted(by: { $0.uploadTime > $1.uploadTime})
                if sortData.count < 20 {
                    self.data = self.data + sortData
                    self.isFinished = true
                }else{
                    self.data = self.data + sortData
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
    
    func getPersonData(completed :@escaping (Status) -> ()) {
        if isFinished {
            return
        }
        
        ConnectionManager.shareManager.request(method: .post, url: String(format: "%@moment/list", Constants.HOST), parames: ["timestamp": NSNumber.init(value: timestamp.toMillis()), "pageIndex": NSNumber.init(value: pageIndex), "pageSize": NSNumber.init(value: pageSize), "token": AuthUtils.share.apiToken() as AnyObject], succeed: { (responseJson) in
            
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            if errorCode == 1 {
                let model = MomentData.deserialize(from: responseJson as? NSDictionary)
                
                guard let md = model else { return }
                
                let sortData = md.data.sorted(by: { $0.uploadTime > $1.uploadTime})
                if sortData.count < 20 {
                    self.data = self.data + sortData
                    self.isFinished = true
                }else{
                    self.data = self.data + sortData
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

class Moment: Resource{
    var body: String = ""
    var type: String = "";
    var comments: [Comment] = []
    var photoArray: [Photo] = []
}

class Creator: HandyJSON{
    var name : String = ""
    var userCode : String = ""
    var avatar: Photo?
    var followingCount: Int = 0
    
    required init() {}
}

class Comment: HandyJSON{
    var commentId: String = ""
    var creator: Creator?
    var body: String = ""
    var replyTo: String = ""
    var replyToName: String = ""
    var childCount: Int = 0
    var comments: [Comment] = []
    
    required init() {}
}

class Link: HandyJSON{
    var link : String = ""
    var icon : String = ""
    var title : String = ""
    
    required init() {}
}















