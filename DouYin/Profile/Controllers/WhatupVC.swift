//
//  WhatupVC.swift
//  DouYin
//
//  Created by Niu Changming on 25/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

typealias UpdateWhatupCallBack = (_ name: String) ->()
class WhatupVC: UITableViewController {
    @IBOutlet weak var messageTv: UITextView!{
        didSet{
            messageTv.delegate = self
        }
    }
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var textAmountLbl: UILabel!
    var completedBlock: UpdateWhatupCallBack?
    
    lazy var personActionBar : PersonActionBar = {
        let personalActionBar = Bundle.main.loadNibNamed("PersonActionBar", owner: nil, options: nil)?[0] as! PersonActionBar
        personalActionBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: Constants.Dimension.NAV_BAR_HEIGHT)
        personalActionBar.delegate = self
        return personalActionBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = self.personActionBar
        tableView.contentInset = UIEdgeInsets(top: -Constants.Dimension.STATUS_BAR_HEIGHT, left: 0, bottom: 0, right: 0)
    }
}

extension WhatupVC: UITextViewDelegate, PersonActionBarDelegate{
    func save() {
        if(Utils.isNotNil(obj: messageTv.text)){
            beforeSave()
            PersonData().saveWhatup(whatup: messageTv.text!) { (status, message) in
                if status == .success {
                    self.dismiss(animated: true, completion: nil)
                    guard let cb = self.completedBlock else {return}
                    cb(self.messageTv.text!)
                }else{
                    Utils.popAlert(title: "Failed", message: message, controller: self)
                }
                self.afterSave()
            }
        } else {
            Utils.popAlert(title: "Failed", message: "Message cannot be empty!", controller: self)
        }
    }
    
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func beforeSave(){
        self.personActionBar.loadingBar.startAnimating()
        self.personActionBar.saveBtn.isHidden = true
    }
    
    func afterSave(){
        self.personActionBar.loadingBar.stopAnimating()
        self.personActionBar.saveBtn.isHidden = false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 200
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == self.messageTv {
            if textView.text.count > 0 {
                self.textAmountLbl.text = String(format: "%i/200", textView.text.count)
                self.placeholderLbl.isHidden = true
            }else {
                self.placeholderLbl.isHidden = false
            }
        }
    }

}
