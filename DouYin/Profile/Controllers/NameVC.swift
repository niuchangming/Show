//
//  NameVC.swift
//  DouYin
//
//  Created by Niu Changming on 25/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

typealias UpdateNameCallBack = (_ name: String) ->()
class NameVC: UITableViewController {

    var isNickname: Bool = false
    @IBOutlet weak var nameTv: InsetTextField!
    @IBOutlet weak var clearBtn: UIButton!
    var completedBlock: UpdateNameCallBack?
    
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
    
    @IBAction func clearBtnClicked(_ sender: Any) {
        self.nameTv.text = ""
    }

}

extension NameVC: PersonActionBarDelegate{
    func save() {
        
        if(Utils.isNotNil(obj: nameTv.text)){
            beforeSave()
            PersonData().saveName(name: nameTv.text!, isNickname: isNickname) { (status, message) in
                if status == .success {
                    self.dismiss(animated: true, completion: nil)
                    guard let cb = self.completedBlock else {return}
                    cb(self.nameTv.text!)
                }else{
                    Utils.popAlert(title: "Failed", message: message, controller: self)
                }
                self.afterSave()
            }
        } else {
            Utils.popAlert(title: "Failed", message: "Your name cannot be empty!", controller: self)
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
}









