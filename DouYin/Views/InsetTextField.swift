//
//  InsetTextField.swift
//  DouYin
//
//  Created by Niu Changming on 11/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class InsetTextField: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8.0, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds:bounds)
    }

}
