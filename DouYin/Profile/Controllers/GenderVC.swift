//
//  GenderVC.swift
//  DouYin
//
//  Created by Niu Changming on 25/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

typealias UpdateGenderCallBack = (_ isMale: Bool) ->()
class GenderVC: UITableViewController {
    var isMale: Bool = true
    var completedBlock: UpdateGenderCallBack?
    
    @IBOutlet weak var maleIcon: UIImageView!{
        didSet{
            maleIcon.image = maleIcon.image?.withRenderingMode(.alwaysTemplate)
            maleIcon.tintColor = UIColor(hexString: Constants.ColorScheme.blueColor)
        }
    }
    
    @IBOutlet weak var femaleIcon: UIImageView!{
        didSet{
            femaleIcon.image = femaleIcon.image?.withRenderingMode(.alwaysTemplate)
            femaleIcon.tintColor = UIColor(hexString: Constants.ColorScheme.pinkColor)
        }
    }
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            let nextIndexPath = IndexPath.init(row: indexPath.row + 1, section: 0)
            tableView.cellForRow(at: nextIndexPath)?.accessoryType = .none
            isMale = true
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            let nextIndexPath = IndexPath.init(row: indexPath.row - 1, section: 0)
            tableView.cellForRow(at: nextIndexPath)?.accessoryType = .none
            isMale = false
        }
    }
   
}

extension GenderVC: PersonActionBarDelegate{
    func save() {
        beforeSave()
        PersonData().saveGender(isMale: isMale) { (status, message) in
            if status == .success {
                self.dismiss(animated: true, completion: nil)
                guard let cb = self.completedBlock else {return}
                cb(self.isMale)
            }else{
                Utils.popAlert(title: "Failed", message: message, controller: self)
            }
            self.afterSave() 
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
