//
//  Work.swift
//  DouYin
//
//  Created by Niu Changming on 14/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import Foundation
import HandyJSON

class VideoData: HandyJSON {
    var total: Int = 0
    var pageIndex: Int = 0
    var pageSize: Int = 20
    var requiredTime = Date()
    var isFinished: Bool = false
    var data = [Video]()
    
    required init() {}
    
    func getData(completed :@escaping (Status) -> ()) {

        if isFinished {
            return
        }

        ConnectionManager.shareManager.request(method: .post, url: String(format: "%@video/listall", Constants.HOST), parames: ["token": AuthUtils.share.apiToken() as AnyObject, "pageIndex": NSNumber.init(value: pageIndex), "pageSize": NSNumber.init(value: pageSize)], succeed: { (responseJson) in

            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            if errorCode == 1 {
                let model = VideoData.deserialize(from: responseJson as? NSDictionary)

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

class Video: HandyJSON {
    var videoId: String = ""
    var uploadTime = Date()
    var preview: Photo?
    var url: String = ""
    var title: String = ""
    var description: String = ""
    var lon: Double = 0
    var lat: Double = 0
    var permission: String = ""
    var category: String = ""
    var creator: Creator?
    var commentCount: Int = 0
    var type: String = "video"
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.videoId <-- "resourceId"
        
        mapper <<<
            self.url <-- "resourceUri"
    }
}









