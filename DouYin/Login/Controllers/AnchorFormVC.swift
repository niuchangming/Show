//
//  AnchorFormVC.swift
//  DouYin
//
//  Created by Niu Changming on 24/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import TLPhotoPicker
import Photos

class AnchorFormVC: UITableViewController, TLPhotosPickerViewControllerDelegate{
    var coverAssets = [TLPHAsset]()
    var avatarAssets = [TLPHAsset]()
    var isCover: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset.top = -UIApplication.shared.statusBarFrame.height
        self.tableView.register(CoverCell.nib(), forCellReuseIdentifier: CoverCell.cellReuseIdentifier())
        self.tableView.register(NameCell.nib(), forCellReuseIdentifier: NameCell.cellReuseIdentifier())
        self.tableView.register(NickCell.nib(), forCellReuseIdentifier: NickCell.cellReuseIdentifier())
        self.tableView.register(GenderCell.nib(), forCellReuseIdentifier: GenderCell.cellReuseIdentifier())
        self.tableView.register(AreaCell.nib(), forCellReuseIdentifier: AreaCell.cellReuseIdentifier())
        self.tableView.register(CategoryCell.nib(), forCellReuseIdentifier: CategoryCell.cellReuseIdentifier())
        self.tableView.register(SubmitCell.nib(), forCellReuseIdentifier: SubmitCell.cellReuseIdentifier())
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!

        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: CoverCell.cellReuseIdentifier(), for: indexPath) as! CoverCell
            (cell as! CoverCell).coverClickHandler = { () in
                self.coverClicked()
            }
            
            (cell as! CoverCell).avatarClickHandler = { () in
                self.avatarClicked()
            }
        }else if indexPath.row == 1{
            cell = tableView.dequeueReusableCell(withIdentifier: NameCell.cellReuseIdentifier(), for: indexPath) as! NameCell
        }else if indexPath.row == 2{
            cell = tableView.dequeueReusableCell(withIdentifier: NickCell.cellReuseIdentifier(), for: indexPath) as! NickCell
        }else if indexPath.row == 3{
            cell = tableView.dequeueReusableCell(withIdentifier: GenderCell.cellReuseIdentifier(), for: indexPath) as! GenderCell
        }else if indexPath.row == 4{
            cell = tableView.dequeueReusableCell(withIdentifier: AreaCell.cellReuseIdentifier(), for: indexPath) as! AreaCell
        }else if indexPath.row == 5{
             cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.cellReuseIdentifier(), for: indexPath) as! CategoryCell
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: SubmitCell.cellReuseIdentifier(), for: indexPath) as! SubmitCell
            (cell as! SubmitCell).clickHandler = { () in
                self.submit()
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 290
        }else if indexPath.row == 6 {
            return 88
        }
        return 50
    }
    
    func setCoverAndAvatar() {
        let indexPath = IndexPath(item: 0, section: 0)
        let coverCell = self.tableView.cellForRow(at: indexPath) as! CoverCell
        if let asset = self.coverAssets.first {
            if let image = asset.fullResolutionImage {
                if self.isCover {
                    coverCell.addCoverView.removeFromSuperview()
                    coverCell.coverIV.image = image
                }else{
                    coverCell.avatarIV.image = image
                }
            }else {
                asset.cloudImageDownload(progressBlock: { [weak self] (progress) in

                    }, completionBlock: { [weak self] (image) in
                        if let image = image {
                            DispatchQueue.main.async {
                                if (self?.isCover)! {
                                    coverCell.coverIV.image = image
                                }else{
                                    coverCell.avatarIV.image = image
                                }
                            }
                        }
                })
            }
        }
    }
    
    func coverClicked(){
        showPickerView(isCover: true)
    }
    
    func avatarClicked(){
        showPickerView(isCover: false)
    }
    
    func showPickerView(isCover: Bool) {
        self.isCover = isCover
        
        let viewController = TLPhotosPickerViewController()
        viewController.delegate = self
        viewController.didExceedMaximumNumberOfSelection = { (picker) in
            let alert = UIAlertController(title: "Alert", message: "Exceed Maximum Number Of Selection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            picker.present(alert, animated: true, completion: nil)
        }
        var configure = TLPhotosPickerConfigure()
        configure.maxSelectedAssets = 1
        configure.allowedVideo = false
        configure.allowedVideoRecording = false
        viewController.configure = configure
        self.present(viewController, animated: true, completion: nil)
    }
    
    func submit(){
        let name: String?
        let nickname: String?
        let gender: String?
        let area: String?
        let category: String?
        
        if(self.coverAssets.count == 0){
            let alert = UIAlertController(title: "Alert", message: "You have to set cover image!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if(self.avatarAssets.count == 0){
            let alert = UIAlertController(title: "Alert", message: "You have to set avatar image!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let nameIndexPath = IndexPath(item: 1, section: 0)
        let nameCell = self.tableView.cellForRow(at: nameIndexPath) as! NameCell
        if(!Utils.isNotNil(obj: nameCell.nameTf.text)){
            let alert = UIAlertController(title: "Alert", message: "Name cannot be empty!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        name = nameCell.nameTf.text
        
        let nickIndexPath = IndexPath(item: 2, section: 0)
        let nickCell = self.tableView.cellForRow(at: nickIndexPath) as! NickCell
        if(!Utils.isNotNil(obj: nickCell.nickTf.text)){
            let alert = UIAlertController(title: "Alert", message: "Nickname cannot be empty!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        nickname = nickCell.nickTf.text
        
        let genderIndexPath = IndexPath(item: 3, section: 0)
        let genderCell = self.tableView.cellForRow(at: genderIndexPath) as! GenderCell
        gender = genderCell.genderSwitch.rightSelected ? genderCell.genderSwitch.rightText : genderCell.genderSwitch.leftText
        
        let areaIndexPath = IndexPath(item: 4, section: 0)
        let areaCell = self.tableView.cellForRow(at: areaIndexPath) as! AreaCell
        area = areaCell.countryLbl.text
        
        let categoryIndexPath = IndexPath(item: 4, section: 0)
        let categoryCell = self.tableView.cellForRow(at: categoryIndexPath) as! CategoryCell
        category = categoryCell.categoryLbl.text
        
        let params = ["name": name, "nickname": nickname, "gender": gender, "countryCode": "65", "category": category, "token": AuthUtils.share.apiToken()]
        let multiParts = ["coverImage": UIImageJPEGRepresentation((self.coverAssets.first?.fullResolutionImage)!, 1), "avatar": UIImageJPEGRepresentation((self.avatarAssets.first?.fullResolutionImage)!, 1)]
        ConnectionManager.shareManager.uploadMultiparts(url: String(format: "%@broadcast/signup", Constants.HOST), params: params as [String : AnyObject], multiparts: multiParts as [String : AnyObject], succeed: { [unowned self] (responseJson) in
                let response = responseJson as! NSDictionary
            }, failure: { (error) in
                
            })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }

}

extension AnchorFormVC {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        if(self.isCover){
            self.coverAssets = withTLPHAssets
            setCoverAndAvatar()
        }else{
            self.avatarAssets = withTLPHAssets
            setCoverAndAvatar()
        }
    }
    
    func canSelectAsset(phAsset: PHAsset) -> Bool {
        return true
    }
    
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        
    }
    
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        
    }
}











