//
//  Work.swift
//  DouYin
//
//  Created by Niu Changming on 14/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import Foundation

struct Work {
    let name: String!
    let coverImage: String!
    let avatarImage: String!
    let latitude: Double!
    let longitude: Double!
    let workLink: String!
    
    init(name: String? = nil, coverImage: String? = nil, avatarImage: String? = nil, latitude: Double? = nil, longitude: Double? = nil, workLink: String? = nil) {
        self.name = name
        self.coverImage = coverImage
        self.avatarImage = avatarImage
        self.latitude = latitude
        self.longitude = longitude
        self.workLink = workLink
    }
}
