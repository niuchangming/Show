//
//  CoverCell.swift
//  DouYin
//
//  Created by Niu Changming on 24/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class CoverCell: UITableViewCell {
    var saveHandler: (() -> Void)!
    var dismissHandler: (() -> Void)!
    var coverClickHandler: (() -> Void)!
    var avatarClickHandler: (() -> Void)!
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var coverIV: UIImageView! {
        didSet{
            coverIV.clipsToBounds = true    
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addCoverViewTapped(tapGestureRecognizer:)))
            addCoverView.isUserInteractionEnabled = true
            addCoverView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @IBOutlet weak var addCoverView: UIView! {
        didSet{
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addCoverViewTapped(tapGestureRecognizer:)))
            addCoverView.isUserInteractionEnabled = true
            addCoverView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @IBOutlet weak var avatarIV: UIImageView! {
        didSet{
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(avatarIvClicked(tapGestureRecognizer:)))
            avatarIV.isUserInteractionEnabled = true
            avatarIV.addGestureRecognizer(tapGestureRecognizer)
            avatarIV.layer.cornerRadius = avatarIV.frame.size.width / 2
            avatarIV.clipsToBounds = true
            avatarIV.layer.shadowColor = UIColor(hexString: Constants.ColorScheme.blackColor).cgColor
            avatarIV.layer.shadowOpacity = 0.5;
            avatarIV.layer.shadowRadius  = 5;
            avatarIV.layer.shadowOffset  = CGSize(width :0, height :0)
            avatarIV.layer.masksToBounds = false;
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static func cellReuseIdentifier() -> String {
        return String(describing: self)
    }
    
    @objc func addCoverViewTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.coverClickHandler()
    }
    
    @objc func avatarIvClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        self.avatarClickHandler()
    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        self.saveHandler()
    }
    
    @IBAction func dismissBtnClicked(_ sender: UIButton) {
        self.dismissHandler()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    override func layoutSubviews() {
    }
    
}
