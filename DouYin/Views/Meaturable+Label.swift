//
//  MeaturableLabel.swift
//  DouYin
//
//  Created by Niu Changming on 4/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

extension UILabel {

    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }

}
