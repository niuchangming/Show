//
//  Moment.swift
//  DouYin
//
//  Created by Niu Changming on 7/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class Moment: NSObject {
    var author: String = ""
    var avatarLink: String = ""
    var body: String = ""
    var type: Int = 0;
    var time: CLong = 0
    var link: Link?
    var comments: [Comment]?
    var pictures: [String] = []
}

class Link: NSObject{
    var link : String = ""
    var icon : String = ""
    var title : String = ""
}

class Comment: NSObject{
    var author: String = ""
    var content: String = ""
}
