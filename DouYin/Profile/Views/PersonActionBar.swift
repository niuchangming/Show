
//
//  PersonActionBar.swift
//  DouYin
//
//  Created by Niu Changming on 25/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

protocol PersonActionBarDelegate: class {
    func save()
    func cancel()
}

class PersonActionBar: UIView {
    
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    weak var delegate: PersonActionBarDelegate?
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.delegate?.cancel()
    }
    @IBAction func saveBtnClicked(_ sender: Any) {
        self.delegate?.save()
    }
    
    
    
    
    
}
