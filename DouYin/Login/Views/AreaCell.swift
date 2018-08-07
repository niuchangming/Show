//
//  AreaCell.swift
//  DouYin
//
//  Created by Niu Changming on 25/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import DropDown

class AreaCell: UITableViewCell {
    var selectedCountry: Country?
    
    @IBOutlet weak var countryLbl: UILabel! {
        didSet{
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCountryPicker(tapGestureRecognizer:)))
            countryLbl.isUserInteractionEnabled = true
            countryLbl.addGestureRecognizer(tapGestureRecognizer)
            countryLbl.text = self.countryPicker.selectedItem
        }
    }
    
    lazy var countryPicker: DropDown = {
        let dropDown = DropDown()
        dropDown.anchorView = self
        dropDown.width = self.countryLbl.frame.size.width
        dropDown.dismissMode = .automatic
        dropDown.direction = .any
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.countryLbl.text = item
        }
        
        let countryData = CountryData()
        countryData.getData(completed: { (isSuccess) in
            if isSuccess {
                let names = countryData.data.map {$0.name}
                dropDown.dataSource = names
                if let country = countryData.data.filter({ $0.name == "Singapore" }).first {
                    self.selectedCountry = country
                    let singaporeIndex = (countryData.data as NSArray).index(of: country)
                    dropDown.selectRow(at: singaporeIndex)
                }
            }
        })
        return dropDown
    }()
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static func cellReuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    @objc func showCountryPicker(tapGestureRecognizer: UITapGestureRecognizer) {
        DropDown.startListeningToKeyboard()
        self.countryPicker.show()
    }

    
}





