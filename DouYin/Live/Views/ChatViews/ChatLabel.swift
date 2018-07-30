//
//  ChatLabel.swift
//  DouYin
//
//  Created by Niu Changming on 29/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class ChatLabel: UILabel {

    override func draw(_ rect: CGRect) {
        let shadowOffset = self.shadowOffset
        let textColor = self.textColor
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx!.setLineWidth(3);
        ctx!.setLineJoin(.round);
        ctx!.setTextDrawingMode(.stroke)
        
        self.textColor = UIColor(hexString: Constants.ColorScheme.blackColor)
        super.drawText(in: rect)
        
        ctx!.setTextDrawingMode(.fill)
        self.textColor = textColor
        self.shadowOffset = CGSize(width: 0, height: 0)
        super.drawText(in: rect)
        self.shadowOffset = shadowOffset
    }

}
