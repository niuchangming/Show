//
//  Resource.swift
//  DouYin
//
//  Created by Niu Changming on 8/9/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import HandyJSON

class Resource: HandyJSON {
    var resourceId: String = ""
    var uploadTime: CLongLong = 0
    var lon: Double = 0
    var lat: Double = 0
    var permission: String = ""
    var creator: Creator?
    var likeCount: Int = 0
    var favouriteCount: Int = 0
    
    required init() {}
}
