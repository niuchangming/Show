//
//  VideoPreviewVC.swift
//  DouYin
//
//  Created by Niu Changming on 17/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import DropDown

class VideoPreviewVC: UITableViewController {
    var previewImage: UIImage!
    var videoUrl: URL!
    
    @IBOutlet weak var locationLbl: UILabel!
    
    var location: Location? {
        didSet {
            locationLbl.text = location.flatMap({ $0.title }) ?? "Singapore"
        }
    }
    
    lazy var locationPickerNavigationVC: UINavigationController = {
        let storyboard = UIStoryboard(name: "Moment", bundle: nil)
        let navigationVC = storyboard.instantiateViewController(withIdentifier: "LocationPickerNavigationVC") as! UINavigationController
        
        let locationPicker = navigationVC.viewControllers[0] as! LocationPickerViewController
        locationPicker.location = location
        locationPicker.showCurrentLocationButton = true
        locationPicker.useCurrentLocationAsHint = true
        locationPicker.selectCurrentLocationInitially = true
        locationPicker.completion = { self.location = $0 }
        
        return navigationVC
    }()
    
    @IBOutlet weak var actionHeader: VideoPreviewHeader!{
        didSet{
            actionHeader.delegate = self
        }
    }
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var atFriendBtn: UIButton!{
        didSet{
            atFriendBtn.clipsToBounds = true
            atFriendBtn.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        }
    }
    @IBOutlet weak var permissionLbl: UILabel!
    @IBOutlet weak var messageTv: UITextView!{
        didSet{
            messageTv.delegate = self
        }
    }
    @IBOutlet weak var previewIv: UIImageView!{
        didSet{
            previewIv.clipsToBounds = true
            previewIv.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        }
    }
    
    lazy var permissionPicker: DropDown = {
        let dropDown = DropDown()
        dropDown.anchorView = self.permissionLbl
        dropDown.width = self.view.frame.size.width / 3
        dropDown.dataSource = ["Public", "Firend", "Private"]
        dropDown.dismissMode = .automatic
        dropDown.direction = .any
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.permissionLbl.text = item
        }
        return dropDown
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        location = nil
        loadViews()
    }
    
    func loadViews(){
        previewIv.image = previewImage
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func atFirendsBtnClicked(_ sender: Any) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            showLocationPicker()
        } else if indexPath.row == 3 {
            DropDown.startListeningToKeyboard()
            self.permissionPicker.show()
        }
    }
    
    func showLocationPicker(){
        self.present(locationPickerNavigationVC, animated: true, completion: nil)
    }
    
    @objc func onNavigationCancelBtnClicked(btn: UIButton){
        locationPickerNavigationVC.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension VideoPreviewVC: VideoPreviewHeaderDelegate, UITextViewDelegate{
    func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func upload() {
        guard let mediaUrl = self.videoUrl else {
            return
        }

        do {
            let lat = LocationManager.share.currentLocation.coordinate.latitude
            let lon = LocationManager.share.currentLocation.coordinate.longitude
            let params = ["title": "", "description": messageTv.text, "lat": String(lat), "lon": String(lon), "category": "", "token": AuthUtils.share.apiToken()!, "permission": (self.permissionLbl.text?.lowercased())!] as [String : Any]
            
            let videoData = try Data(contentsOf: mediaUrl, options: .mappedIfSafe)
            let multiParts = ["videofile": videoData, "preview": UIImageJPEGRepresentation(self.previewImage, 1)]
        
            beforeUpload()
            ConnectionManager.shareManager.uploadMultiparts(url: String(format: "%@video/upload", Constants.HOST), params: params as [String : AnyObject], multiparts: multiParts as [String : AnyObject], mimeType: "video/*", succeed: { (responseJson) in
                
                let response = responseJson as! NSDictionary
                let errorCode = response["errorCode"] as! Int
                let message = response["message"] as! String
                if errorCode == 1 {
                    self.dismiss(animated: true)
                }else{
                    Utils.popAlert(title: "Failed", message: message, controller: self)
                }
                self.afterUpload()
                
            }) { (error) in
                Utils.popAlert(title: "Failed", message: error?.localizedDescription, controller: self)
                self.afterUpload()
            }
            
        } catch {
            print("Upload Video Failed")
        }
    }
    
    func beforeUpload(){
        self.actionHeader.loadingBar.startAnimating()
        self.actionHeader.uploadBtn.isHidden = true
    }
    
    func afterUpload(){
        self.actionHeader.loadingBar.stopAnimating()
        self.actionHeader.uploadBtn.isHidden = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == self.messageTv {
            if textView.text.count > 0 {
                self.placeholderLbl.isHidden = true
            }else {
                self.placeholderLbl.isHidden = false
            }
        }
    }
}













