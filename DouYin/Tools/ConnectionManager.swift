//
//  ConnectionManager.swift
//  NDFX_swift
//
//  Created by 李家奇_南湖国旅 on 2017/6/13.
//  Copyright © 2017年 李家奇_南湖国旅. All rights reserved.
//

import UIKit
import Alamofire

enum Status {
    case success
    case failure
}

class ConnectionManager: NSObject {

    static let shareManager : ConnectionManager = {
        let manager = ConnectionManager()
        
        return manager
    }()
    
    func request(method: HTTPMethod, url:String, parames:[String:AnyObject]?, succeed:@escaping(AnyObject?)->(), failure:@escaping(Error?)->() ) {
        
        Alamofire.request(url, method:method, parameters:parames).responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value{
                    succeed(value as AnyObject)
                }
            case .failure:
                failure(response.result.error)
            }
        }
    }
    
    func uploadMultiparts(url: String, params: [String:AnyObject], multiparts: [String:AnyObject]?, succeed: @escaping(AnyObject?)->(), failure:@escaping(Error?)->()) {
        
        uploadMultiparts(url: url, params: params, multiparts: multiparts, mimeType: "image/jpeg", succeed: succeed, failure: failure)
        
    }
    
    func uploadMultiparts(url: String, params: [String:AnyObject], multiparts: [String:AnyObject]?, mimeType: String, succeed: @escaping(AnyObject?)->(), failure:@escaping(Error?)->()) {
    
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in params {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }
            
            if multiparts != nil {
                for (key, partData) in multiparts! {
                    
                    if let dataArr = partData as? [Data]{
                        for data in dataArr {
                            multipartFormData.append(data , withName: key, fileName: UUID().uuidString, mimeType: mimeType)
                        }
                    } else {
                        multipartFormData.append(partData as! Data, withName: key, fileName: UUID().uuidString, mimeType: mimeType)
                    }
                    
                }
            }
            
        }, to: url, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let value = response.result.value {
                        succeed(value as AnyObject)
                    }else{
                        failure(response.result.error)
                    }
                }
            case .failure(let encodingError):
                failure(encodingError)
            }
        })
    }
    
}











