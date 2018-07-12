//
//  Utils.swift
//  DouYin
//
//  Created by Niu Changming on 5/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    static func makeGradientColor(`for` object : AnyObject) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [(UIColor(hexString: Constants.ColorScheme.redColor).cgColor), (UIColor(hexString: Constants.ColorScheme.orangeColor).cgColor)]
        gradient.locations = [0.0 , 1.0]
        
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: object.frame.size.width, height: object.frame.size.height)
        return gradient
    }
    
    static func isNotNil(obj: Any?) -> Bool {
        if obj is String {
            if (obj as? String) != nil {
                return true
            }else {
                return false
            }
        }else if obj is Array<Any> {
            if (obj as? Array<Any>) != nil {
                return true
            }else {
                return false
            }
        }else if obj is Dictionary<AnyHashable, Any> {
            if (obj as? Dictionary<String, Any>) != nil {
                return true
            }else {
                return false
            }
        }else if obj is Data {
            if (obj as? Data) != nil {
                return true
            }else {
                return false
            }
        }else if obj is NSNumber {
            if (obj as? NSNumber) != nil{
                return true
            }else {
                return false
            }
        }else if obj is UIImage {
            if (obj as? UIImage) != nil {
                return true
            }else {
                return false
            }
        }
        return false
    }
}
