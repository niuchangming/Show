//
//  RegionListVC.swift
//  DouYin
//
//  Created by Niu Changming on 25/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
typealias UpdateRegionCallBack = (_ name: String) ->()
class RegionListVC: UITableViewController {
    let countryData = CountryData()
    var selectedIndex: Int = 0
    var previousSelectedIndex: Int = 0
    var completedBlock: UpdateRegionCallBack?
    
    lazy var personActionBar : PersonActionBar = {
        let personalActionBar = Bundle.main.loadNibNamed("PersonActionBar", owner: nil, options: nil)?[0] as! PersonActionBar
        personalActionBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: Constants.Dimension.NAV_BAR_HEIGHT)
        personalActionBar.delegate = self
        return personalActionBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = self.personActionBar
        tableView.contentInset = UIEdgeInsets(top: -Constants.Dimension.STATUS_BAR_HEIGHT, left: 0, bottom: 0, right: 0)
        countryData.getData(completed: { (isSuccess) in
            if isSuccess {
                if let country = self.countryData.data.filter({ $0.name == "Singapore" }).first {
                    self.selectedIndex = (self.countryData.data as NSArray).index(of: country)
                    self.previousSelectedIndex = self.selectedIndex
                }
                self.tableView.reloadData()
            }
        })
        self.personActionBar.titleLbl.text = "Region"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryData.data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionCell", for: indexPath)
        
        let titleLbl = cell.viewWithTag(1) as! UILabel
        titleLbl.text = countryData.data[indexPath.row].name
        
        if(indexPath.row == self.selectedIndex){
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row

        let selectedIndexPath = IndexPath.init(row: self.selectedIndex, section: 0)
        let selectedCell = tableView.cellForRow(at: selectedIndexPath)
        selectedCell?.accessoryType = .checkmark
        
        let previousindexPath = IndexPath.init(row: self.previousSelectedIndex, section: 0)
        let previousSelectedCell = tableView.cellForRow(at: previousindexPath)
        previousSelectedCell?.accessoryType = .none
        
        self.previousSelectedIndex = self.selectedIndex
    }

}

extension RegionListVC: PersonActionBarDelegate{
    func save() {
        let country = self.countryData.data[self.selectedIndex]
        
        beforeSave()
        PersonData().saveRegion(country: country) { (status, message) in
            if status == .success {
                self.dismiss(animated: true, completion: nil)
                guard let cb = self.completedBlock else {return}
                cb(country.name)
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
