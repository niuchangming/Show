//
//  Date+Utils.swift
//  DouYin
//
//  Created by Niu Changming on 28/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    init(millis: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(millis / 1000))
        self.addTimeInterval(TimeInterval(Double(millis % 1000) / 1000 ))
    }
    
}