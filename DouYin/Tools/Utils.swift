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
}
