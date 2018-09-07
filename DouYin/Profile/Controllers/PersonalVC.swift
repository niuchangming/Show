//
//  PersonalIVC.swift
//  DouYin
//
//  Created by Niu Changming on 24/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import TLPhotoPicker
import Photos

class PersonalVC: UITableViewController {
    var coverAssets = [TLPHAsset]()
    var avatarAssets = [TLPHAsset]()
    var isCover: Bool = true
    var isLoadingCover = false
    var isLoadingAvatar = false
    var person: Person?
    
    @IBOutlet weak var coverIv: UIImageView!
    @IBOutlet weak var editCoverBtn: UIButton! {
        didSet{
            editCoverBtn.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
            editCoverBtn.clipsToBounds = true
            editCoverBtn.isHidden = true
        }
    }
    @IBOutlet weak var coverLoadingbar: UIActivityIndicatorView!
    
    @IBOutlet weak var avatarLoadinfBar: UIActivityIndicatorView!
    @IBOutlet weak var avatarIv: UIImageView!{
        didSet{
            avatarIv.layer.cornerRadius = avatarIv.frame.size.width / 2
        }
    }
    @IBOutlet weak var changeAvatarBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameIcon: UIImageView!{
        didSet{
            nameIcon.image = nameIcon.image?.withRenderingMode(.alwaysTemplate)
            nameIcon.tintColor = UIColor(hexString: Constants.ColorScheme.darkBlackColor)
        }
    }
    
    @IBOutlet weak var nicknameLbl: UILabel!
    @IBOutlet weak var nicknameIcon: UIImageView!{
        didSet{
            nicknameIcon.image = nicknameIcon.image?.withRenderingMode(.alwaysTemplate)
            nicknameIcon.tintColor = UIColor(hexString: Constants.ColorScheme.darkBlackColor)
        }
    }
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var genderIcon: UIImageView!{
        didSet{
            genderIcon.image = genderIcon.image?.withRenderingMode(.alwaysTemplate)
            genderIcon.tintColor = UIColor(hexString: Constants.ColorScheme.darkBlackColor)
        }
    }
    @IBOutlet weak var birthdayLbl: UILabel!
    @IBOutlet weak var birthdayIcon: UIImageView!{
        didSet{
            birthdayIcon.image = birthdayIcon.image?.withRenderingMode(.alwaysTemplate)
            birthdayIcon.tintColor = UIColor(hexString: Constants.ColorScheme.darkBlackColor)
        }
    }
    @IBOutlet weak var whatupLbl: UILabel!
    @IBOutlet weak var whatupIcon: UIImageView!{
        didSet{
            whatupIcon.image = whatupIcon.image?.withRenderingMode(.alwaysTemplate)
            whatupIcon.tintColor = UIColor(hexString: Constants.ColorScheme.darkBlackColor)
        }
    }
    
    @IBOutlet weak var regionLbl: UILabel!
    @IBOutlet weak var regionIcon: UIImageView!{
        didSet{
            regionIcon.image = regionIcon.image?.withRenderingMode(.alwaysTemplate)
            regionIcon.tintColor = UIColor(hexString: Constants.ColorScheme.darkBlackColor)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        if Utils.isNotNil(obj: person) {
            updateViews()
        }
    }
    
    func updateViews(){
        if Utils.isNotNil(obj: person?.name) {
            self.nameLbl.text = person?.name
        }
        
        if Utils.isNotNil(obj: person?.nickName) {
            self.nameLbl.text = person?.nickName
        }
        
        self.genderLbl.text = person?.gender == 0 ? "Male" : "Female"
        
        if (person?.birthday)! > 0 {
            let birthdayDate = Date.init(millis: (person?.birthday)!)
            self.birthdayLbl.text = birthdayDate.toDateStr()
        }
        
        if Utils.isNotNil(obj: person?.region) {
            self.regionLbl.text = person?.region
        }
        
        if Utils.isNotNil(obj: person?.avatar) {
            avatarIv.sd_setImage(with: URL(string: (person?.avatar?.origin)!), placeholderImage: UIImage(named: "placeholder.png"))
        }
        
        if person?.role == 2 { //主播
            editCoverBtn.isHidden = false
            
            guard let cover = person?.coverImage else { return }
            coverIv.sd_setImage(with: URL(string: cover.origin), placeholderImage: UIImage(named: "placeholder.png")) { (image, error, cacheType, url) in
                let blurImage: UIImage = (image!.gaussianBlur(blurAmount: 5))
                self.coverIv.image = blurImage
            }
        } else {
            guard let avatar = person?.avatar else { return }
            coverIv.sd_setImage(with: URL(string: avatar.origin), placeholderImage: UIImage(named: "placeholder.png")) { (image, error, cacheType, url) in
                let blurImage: UIImage = (image!.gaussianBlur(blurAmount: 5))
                self.coverIv.image = blurImage
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "PersonalInfo", bundle: nil)
        if indexPath.row == 1 {
            let nameVC = storyboard.instantiateViewController(withIdentifier: "NameVC") as! NameVC
            nameVC.isNickname = false
            nameVC.completedBlock = { (name) -> () in
                self.nameLbl.text = name
            }
            self.present(nameVC, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            let nameVC = storyboard.instantiateViewController(withIdentifier: "NameVC") as! NameVC
            nameVC.isNickname = true
            nameVC.completedBlock = { (name) -> () in
                self.nicknameLbl.text = name
            }
            self.present(nameVC, animated: true, completion: nil)
        } else if indexPath.row == 3 {
            let genderVC = storyboard.instantiateViewController(withIdentifier: "GenderVC") as! GenderVC
            genderVC.completedBlock = { (isMale) -> () in
                self.genderLbl.text = isMale ? "Male" : "Female"
            }
            self.present(genderVC, animated: true, completion: nil)
        } else if indexPath.row == 4 {
            let birthdayVC = storyboard.instantiateViewController(withIdentifier: "BirthdayVC") as! BirthdayVC
            birthdayVC.completedBlock = {(birthday) -> () in
                self.birthdayLbl.text = birthday
            }
            self.present(birthdayVC, animated: true, completion: nil)
        } else if indexPath.row == 5 {
            let whatupVC = storyboard.instantiateViewController(withIdentifier: "WhatupVC") as! WhatupVC
            whatupVC.completedBlock = { (whatup) -> () in
                self.whatupLbl.text = whatup
            }
            self.present(whatupVC, animated: true, completion: nil)
        } else if indexPath.row == 6 {
            let regionVC = storyboard.instantiateViewController(withIdentifier: "RegionListVC") as! RegionListVC
            regionVC.completedBlock = { (region) ->  () in
                self.regionLbl.text = region
            }
            self.present(regionVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func changeAvatarBtnClicked(_ sender: Any) {
        self.isCover = false
        showPickerView()
    }
    
    @IBAction func editCoverBtnClicked(_ sender: Any) {
        self.isCover = true
        showPickerView()
    }

    func showPickerView() {
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
    
    func setCoverAndAvatar() {
        let targetAssets: [TLPHAsset]!
        if(self.isCover){
            targetAssets = self.coverAssets
        }else{
            targetAssets = self.avatarAssets
        }
        
        if let asset = targetAssets.first {
            if let image = asset.fullResolutionImage {
                if self.isCover {
                    self.coverIv.image = image
                }else{
                    self.avatarIv.image = image
                    self.avatarIv.layer.cornerRadius = self.avatarIv.frame.size.width / 2
                    self.avatarIv.clipsToBounds = true
                }
                uploadImage(image: image)
            }else {
                asset.cloudImageDownload(progressBlock: { [weak self] (progress) in
                    
                    }, completionBlock: { [weak self] (image) in
                    if let image = image {
                        DispatchQueue.main.async {
                            if (self?.isCover)! {
                                self?.coverIv.image = image
                            }else{
                                self?.avatarIv.image = image
                            }
                        }
                        self?.uploadImage(image: image)
                    }
                })
            }
        }
    }
    
    func uploadImage(image: UIImage){
        beforeUpload()
        PersonData().uploadImage(isCover: isCover, image:image) { (status, message, isCover) in
            if status == .failure {
                Utils.popAlert(title: "Failed", message: message, controller: self)
            }
            self.afterUpload(isCover: isCover)
        }
    }
    
    func beforeUpload(){
        if isCover {
            self.isLoadingCover = true
            self.editCoverBtn.isUserInteractionEnabled = false
            self.editCoverBtn.setTitle("", for: .normal)
            self.coverLoadingbar.startAnimating()
        } else {
            self.isLoadingAvatar = true
            self.changeAvatarBtn.isUserInteractionEnabled = false
            self.avatarLoadinfBar.startAnimating()
        }
    }
    
    func afterUpload(isCover: Bool){
        if isCover {
            self.isLoadingCover = false
            self.editCoverBtn.isUserInteractionEnabled = true
            self.editCoverBtn.setTitle("Edit Cover", for: .normal)
            self.coverLoadingbar.stopAnimating()
        } else {
            self.isLoadingAvatar = false
            self.changeAvatarBtn.isUserInteractionEnabled = true
            self.avatarLoadinfBar.stopAnimating()
        }
    }
}

extension PersonalVC: TLPhotosPickerViewControllerDelegate{
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        if(self.isCover){
            self.coverAssets = withTLPHAssets
        }else{
            self.avatarAssets = withTLPHAssets
        }
        setCoverAndAvatar()
    }
    
    func canSelectAsset(phAsset: PHAsset) -> Bool {
        return true
    }
    
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        
    }
    
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        
    }
}




















