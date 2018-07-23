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
            if (obj as? String) != nil{
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
    
    static func viewController(responder: UIResponder) -> UIViewController? {
        if let vc = responder as? UIViewController {
            return vc
        }
        
        if let next = responder.next {
            return viewController(responder: next)
        }
    
        return nil
    }
    
    static func isNumber(str: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: str)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    static func deviceId() -> String{
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    static func fakeName() -> String{
        let names = ["阙造", "广锡一", "席寺", "扶驾", "郑萱黄", "林樊牵", "孟登元", "鱼彰", "皮忧暑", "左稗", "宦醇", "糜弋招", "席准", "方抑", "乌泔", "苗鲁", "孟候依", "龙珠饯", "洪打鹰", "缪负铎"]
    
        return names[Int(arc4random_uniform(UInt32(names.count)))]
    }
    
    static func stringToDictionary(str: String) -> [String: Any]? {
        if let data = str.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
