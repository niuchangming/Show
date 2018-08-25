//
//  BirthdayVC.swift
//  DouYin
//
//  Created by Niu Changming on 25/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

typealias UpdateBirthdayCallBack = (_ birthday: String) ->()
class BirthdayVC: UITableViewController {
    
    var completedBlock: UpdateBirthdayCallBack?
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 260))
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date();
        datePicker.addTarget(self, action: #selector(BirthdayVC.dateSelected(datePicker:)), for: .valueChanged)
        return datePicker
    }()

    @IBOutlet weak var birthIcon: UIImageView!{
        didSet{
            birthIcon.image = birthIcon.image?.withRenderingMode(.alwaysTemplate)
            birthIcon.tintColor = UIColor(hexString: Constants.ColorScheme.darkBlackColor)
        }
    }
    
    @IBOutlet weak var birthdayLbl: UILabel!
    
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

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDatePicker()
    }
    
    func showDatePicker(){
        let alertController = UIAlertController(title: "Choose Your Birthday", message:nil, preferredStyle: .actionSheet)
        alertController.view.addSubview(self.datePicker)
        
        let cancelAction = UIAlertAction(title: "Done", style: .cancel) { (action) in
            self.dateSelected(datePicker: self.datePicker)
        }
        alertController.addAction(cancelAction)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        alertController.view.addConstraint(height);
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func dateSelected(datePicker:UIDatePicker){
        self.birthdayLbl.text = datePicker.date.toDateStr()
    }
}

extension BirthdayVC: PersonActionBarDelegate{
    func save() {
        
        if(Utils.isNotNil(obj: birthdayLbl.text)){
            beforeSave()
            PersonData().saveBirthday(birthday: Date.stringToDate(str: birthdayLbl.text!)) { (status, message) in
                if status == .success {
                    self.dismiss(animated: true, completion: nil)
                    guard let cb = self.completedBlock else {return}
                    cb(self.birthdayLbl.text!)
                }else{
                    Utils.popAlert(title: "Failed", message: message, controller: self)
                }
                self.afterSave()
            }
        }else{
            Utils.popAlert(title: "Sorry", message: "Birthday format is invalid!", controller: self)
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



