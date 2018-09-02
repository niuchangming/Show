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
    
    func toDateStr() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func toShortDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: self)
    }
    
    static func stringToDate(str: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        
        guard let date = dateFormatter.date(from: str) else {
            return Date()
        }
        return date
    }
    
    func getElapsedInterval() -> String {
        
        var interval = Calendar.current.dateComponents([.year], from: self, to: Date()).year!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " year ago" : "\(interval)" + " years ago"
        }
        
        interval = Calendar.current.dateComponents([.month], from: self, to: Date()).month!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " month ago" : "\(interval)" + " months ago"
        }
        
        interval = Calendar.current.dateComponents([.day], from: self, to: Date()).day!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " day ago" : "\(interval)" + " days ago"
        }
        
        interval = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " hour ago" : "\(interval)" + " hours ago"
        }
        
        interval = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " minute ago" : "\(interval)" + " minutes ago"
        }
        
        return "a moment ago"
    }
}
