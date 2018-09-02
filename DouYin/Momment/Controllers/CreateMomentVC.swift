//
//  CreateMomentVC.swift
//  DouYin
//
//  Created by Niu Changming on 9/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import TLPhotoPicker
import Photos
import DropDown

typealias CompletedCallBack = (_ moment: Moment?) ->()
class CreateMomentVC: UIViewController {
    var postType: MomentType! = .text
    let maxImageAmount: Int = 9
    var imageAssets = [TLPHAsset]()
    @IBOutlet weak var messageTv: UITextView! {
        didSet{
            messageTv.delegate = self
        }
    }
    
    @IBOutlet weak var actionBar: UIView!
    @IBOutlet weak var actionBarHeight: NSLayoutConstraint!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var imageContainerHeightContraint: NSLayoutConstraint!
    var completedBlock: CompletedCallBack?
    @IBOutlet weak var arrowIv: UIImageView!{
        didSet{
            arrowIv.image = arrowIv.image?.withRenderingMode(.alwaysTemplate)
            arrowIv.tintColor = UIColor(hexString: Constants.ColorScheme.grayColor)
        }
    }
    @IBOutlet weak internal var postBtn: UIButton!
    
    @IBOutlet weak var palceholderLbl: UILabel!
    @IBOutlet weak var permissionView: UIView! {
        didSet{
            let gestureTap = UITapGestureRecognizer(target: self, action: #selector (CreateMomentVC.showPermissions))
            permissionView.addGestureRecognizer(gestureTap)
        }
    }
    
    @IBOutlet weak var permissionIconIv: UIImageView! {
        didSet{
            permissionIconIv.image = permissionIconIv.image?.withRenderingMode(.alwaysTemplate)
            permissionIconIv.tintColor = UIColor(hexString: Constants.ColorScheme.darkBlackColor)
        }
    }
    
    @IBOutlet weak var permissionViewTopToMessageTv: NSLayoutConstraint!
    @IBOutlet weak var permissionViewTopToImageContainer: NSLayoutConstraint!
    @IBOutlet weak var permissionLbl: UILabel!
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    
    lazy var addMoreIV: UIImageView! = {
        let addImageView = UIImageView()
        addImageView.contentMode = .scaleAspectFill
        addImageView.clipsToBounds = true
        addImageView.isUserInteractionEnabled = true
        addImageView.image = UIImage(named: "add_image")
        return addImageView
    }()
    
    lazy var permissionPicker: DropDown = {
        let dropDown = DropDown()
        dropDown.anchorView = self.permissionView
        dropDown.width = self.permissionView.frame.size.width / 3
        dropDown.dataSource = ["Public", "Follower", "Private"]
        dropDown.dismissMode = .automatic
        dropDown.direction = .any
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.permissionLbl.text = item
        }
        return dropDown
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.postType == .text {
            self.imageContainer.isHidden = true
            self.permissionViewTopToImageContainer.priority = UILayoutPriority(rawValue: 750)
            self.permissionViewTopToMessageTv.constant = 20
            self.permissionViewTopToMessageTv.priority = UILayoutPriority(rawValue: 999)
        }else{
            self.imageContainer.isHidden = false
            self.permissionViewTopToImageContainer.priority = UILayoutPriority(rawValue: 999)
            self.permissionViewTopToMessageTv.priority = UILayoutPriority(rawValue: 750)
            updateImagesContainer()
        }
        self.actionBarHeight.constant = self.actionBar.frame.size.height + Constants.Dimension.STATUS_BAR_HEIGHT
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        permissionView.addBorder(side: .top, thickness: 0.5, color: UIColor(hexString: Constants.ColorScheme.grayColor))
        permissionView.addBorder(side: .bottom, thickness: 0.5, color: UIColor(hexString: Constants.ColorScheme.grayColor))
    }
    
    func updateImagesContainer(){
        for view in self.imageContainer.subviews {
            view.removeFromSuperview()
        }
        
        let imageWidth: CGFloat = CGFloat(100) * Constants.Dimension.W_RATIO;
        let imageHeight: CGFloat = imageWidth
        let gap: CGFloat = CGFloat(10)
        let marginParentLeft: CGFloat = (self.imageContainer.frame.size.width - CGFloat(3)*imageWidth - CGFloat(2) * gap) / CGFloat(2)

        var rowNum: Int = 0
        for i in 0..<imageAssets.count {
            if(i % 3 == 0){
                rowNum = rowNum + 1
            }
        }
        
        let colNum: Int = 3
        if imageAssets.count > 0 {
            for row in 0..<rowNum {
                for col in 0..<colNum {
                    if(colNum*row + col < imageAssets.count){
                        let imageView = UIImageView(frame: CGRect(x: marginParentLeft+CGFloat(col)*(imageWidth+gap), y: CGFloat(row)*imageHeight+(CGFloat(row) + 1) * gap, width: imageWidth, height: imageHeight))
                        imageView.image = imageAssets[colNum * row + col].fullResolutionImage
                        imageView.contentMode = .scaleAspectFill
                        imageView.clipsToBounds = true
                        self.imageContainer.addSubview(imageView)
                    }else{
                        break;
                    }
                }
            }
        }
    
        if imageAssets.count < maxImageAmount {
            let yushu = imageAssets.count % 3
            if yushu == 0 {
                self.addMoreIV.frame = CGRect(x: CGFloat(gap), y: CGFloat(rowNum) * imageHeight + CGFloat(rowNum + 1) * gap, width: imageWidth, height: imageHeight)
                self.imageContainerHeightContraint.constant = CGFloat(rowNum + 1) * imageHeight + CGFloat(rowNum + 1) * gap
            }else{
                self.addMoreIV.frame = CGRect(x: CGFloat(yushu + 1)*gap+CGFloat(yushu)*imageWidth, y: CGFloat(rowNum - 1) * imageHeight + CGFloat(rowNum) * gap, width: imageWidth, height: imageHeight)
                self.imageContainerHeightContraint.constant = imageHeight * CGFloat(rowNum) + gap * CGFloat(rowNum)
            }
            self.imageContainer.addSubview(self.addMoreIV)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImages(_:)))
            self.addMoreIV.addGestureRecognizer(tapGestureRecognizer)
        }else {
            self.imageContainerHeightContraint.constant = imageHeight * CGFloat(rowNum) + gap * CGFloat(rowNum)
        }
    }

    @IBAction func pickImages(_ sender: Any) {
        if imageAssets.count < maxImageAmount {
            let viewController = TLPhotosPickerViewController()
            viewController.delegate = self
            viewController.didExceedMaximumNumberOfSelection = { (picker) in
                
                let alert = UIAlertController(title: "Alert", message: "Exceed Maximum Number Of Selection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                picker.present(alert, animated: true, completion: nil)
                
            }
            
            var configure = TLPhotosPickerConfigure()
            configure.maxSelectedAssets = maxImageAmount - imageAssets.count
            configure.allowedVideo = false
            configure.allowedVideoRecording = false
            viewController.configure = configure
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    @objc func showPermissions(){
        DropDown.startListeningToKeyboard()
        permissionPicker.show();
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postBtnClicked(_ sender: Any) {
        postMoment()
    }
    
    func postMoment(){
        var pictureData: [Data]? = nil
        var pictureArr: [String: AnyObject]? = nil
        if postType == .text {
            if(!Utils.isNotNil(obj: messageTv.text)){
                Utils.popAlert(title: "Failed", message: "Body cannot be empty!", controller: self)
                return
            }
        }else{
            if(self.imageAssets.count == 0){
                Utils.popAlert(title: "Failed", message: "Body cannot be empty!", controller: self)
                return
            }
            pictureData = [Data]()
        }
        
        let postUrl = String(format: "%@moment/publish", Constants.HOST)
        let lat = LocationManager.share.currentLocation.coordinate.latitude
        let lon = LocationManager.share.currentLocation.coordinate.longitude
        
        let params = ["token": AuthUtils.share.apiToken()!, "body": messageTv.text!, "type": postType.rawValue, "lat": String(lat), "lon": String(lon), "permission": permissionLbl.text?.lowercased() as Any] as [String : Any]
    
        for tlphAsset in self.imageAssets {
            pictureData?.append(UIImageJPEGRepresentation(tlphAsset.fullResolutionImage!, 1)!)
        }
        
        if pictureData != nil && (pictureData?.count)! > 0 {
            pictureArr = ["momentPhotos" : pictureData as AnyObject]
        }
    
        beforePost()
        ConnectionManager.shareManager.uploadMultiparts(url: postUrl, params: params as [String : AnyObject], multiparts: pictureArr, succeed: { (responseJson) in
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            let message = response["message"] as! String
            if errorCode == 1 {
                let newMoment = Moment.deserialize(from: response["data"] as? NSDictionary)
                
                self.dismiss(animated: true, completion: nil)
                guard let cb = self.completedBlock else {return}
                cb(newMoment)
            }else{
                Utils.popAlert(title: "Failed", message: message, controller: self)
            }
            self.afterPost()
        }) { (error) in
            Utils.popAlert(title: "Failed", message: error?.localizedDescription, controller: self)
            self.afterPost()
        }
    }
    
    func beforePost(){
        loadingBar.startAnimating()
        postBtn.isHidden = true
    }
    func afterPost(){
        self.loadingBar.stopAnimating()
        self.postBtn.isHidden = false
    }
}

extension CreateMomentVC: TLPhotosPickerViewControllerDelegate, UITextViewDelegate{
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        var maxAddAmount = maxImageAmount - self.imageAssets.count;
        if withTLPHAssets.count > 0 {
            for i in 0..<withTLPHAssets.count {
                if maxAddAmount > 0 {
                    self.imageAssets.append(withTLPHAssets[i])
                }
                maxAddAmount = maxAddAmount - 1
            }
            
            self.updateImagesContainer()
        }
    }
    
    func canSelectAsset(phAsset: PHAsset) -> Bool {
        return true
    }
    
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        
    }
    
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == self.messageTv {
            if textView.text.count > 0 {
                self.palceholderLbl.isHidden = true
            }else {
                self.palceholderLbl.isHidden = false
            }
        }
    }
}
