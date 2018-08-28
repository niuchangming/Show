//
//  CommentTextBar.swift
//  DouYin
//
//  Created by Niu Changming on 13/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class CommentTextBar: UIView {
    @IBOutlet weak var commentTF: UITextField!{
        didSet{
            commentTF.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
            commentTF.clipsToBounds = true
        }
    }
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBAction func sendBtnClicked(_ sender: UIButton) {
        
    }
    

}
