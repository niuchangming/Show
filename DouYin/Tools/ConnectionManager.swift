//
//  ConnectionManager.swift
//  NDFX_swift
//
//  Created by 李家奇_南湖国旅 on 2017/6/13.
//  Copyright © 2017年 李家奇_南湖国旅. All rights reserved.
//

import UIKit
import Alamofire

enum ConnectionType {
    case Get
    case Post
}

class ConnectionManager: NSObject {

    static let shareManager : ConnectionManager = {
        let manager = ConnectionManager()
        
        return manager
    }()
    
    func request(Type: ConnectionType, url:String, parames:[String:AnyObject], succeed:@escaping(String?, AnyObject?)->(), failure:@escaping(String?)->() ) {
        
        Alamofire.request(url, method:.get, parameters:parames).responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value{
                    succeed("succeed", value as AnyObject)
                }
            case .failure:
                failure("failure")
            }
        }
    }
    
}











