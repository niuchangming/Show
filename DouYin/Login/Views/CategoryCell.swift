//
//  CategoryCell.swift
//  DouYin
//
//  Created by Niu Changming on 26/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import DropDown

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryLbl: UILabel! {
        didSet{
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCategoryPicker(tapGestureRecognizer:)))
            categoryLbl.isUserInteractionEnabled = true
            categoryLbl.addGestureRecognizer(tapGestureRecognizer)
            categoryLbl.text = "搞笑"
        }
    }
    
    lazy var categoryPicker: DropDown = {
        let dropDown = DropDown()
        dropDown.anchorView = self
        dropDown.width = self.categoryLbl.frame.size.width
        dropDown.dataSource = ["搞笑", "美女", "帅哥", "才艺", "其它"]
        dropDown.dismissMode = .automatic
        dropDown.direction = .any
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.categoryLbl.text = item
        }
        return dropDown
    }()

    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static func cellReuseIdentifier() -> String {
        return String(describing: self)
    }

    @objc func showCategoryPicker(tapGestureRecognizer: UITapGestureRecognizer) {
        DropDown.startListeningToKeyboard()
        self.categoryPicker.show()
    }
    
}
