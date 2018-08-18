//
//  VideoPreviewHeader.swift
//  DouYin
//
//  Created by Niu Changming on 18/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

protocol VideoPreviewHeaderDelegate: class {
    func upload()
    func goBack()
}

class VideoPreviewHeader: ReusableViewFromXib {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    weak var delegate: VideoPreviewHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    @IBAction func uploadBtnClicked(_ sender: Any) {
        self.delegate?.upload()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.delegate?.goBack()
    }

}
































