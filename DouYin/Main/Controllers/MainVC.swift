//
//  MainVC.swift
//  DouYin
//
//  Created by Niu Changming on 19/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import Parchment
import SendBirdSDK
import CoreLocation
import TLPhotoPicker
import Photos

enum MomentType: String {
    case text = "text"
    case picture = "picture"
    case video = "video"
    
    static func iterateEnum() -> AnyIterator<ChatType> {
        var i = 0
        return AnyIterator {
            let next = withUnsafeBytes(of: &i) { $0.load(as: ChatType.self) }
            if next.hashValue != i { return nil }
            i += 1
            return next
        }
    }
}

class CustomPagingView: PagingView {
    
    override func setupConstraints() {
        constrainToEdges(pageView)
    }
}

class CustomPagingViewController: FixedPagingViewController {
    override func loadView() {
        view = CustomPagingView(
            options: options,
            collectionView: collectionView,
            pageView: pageViewController.view)
    }
}

class MainVC: UIViewController {
    
    var isVideo: Bool! = false
    var postType: MomentType! = .text
    
    lazy var recommandVC: ShortVideoVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShortVideoVC") as! ShortVideoVC
        vc.title = "视频"
        return vc
    }()
    
    lazy var featuredVC: LiveListVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LiveListVC") as! LiveListVC
        vc.title = "直播"
        return vc
    }()
    
    lazy var momentVC: MomentVC = {
        let vc = MomentVC()
        vc.title = "图文"
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let pagingViewController = CustomPagingViewController(viewControllers: [self.momentVC, self.recommandVC, self.featuredVC])
        pagingViewController.delegate = self
        pagingViewController.borderOptions = .hidden
        pagingViewController.menuBackgroundColor = .clear
        pagingViewController.indicatorColor = UIColor(hexString: Constants.ColorScheme.blackColor)
        pagingViewController.textColor = UIColor(hexString: Constants.ColorScheme.blackColor).withAlphaComponent(0.5)
        pagingViewController.selectedTextColor = UIColor(hexString: Constants.ColorScheme.blackColor)
        pagingViewController.selectedFont = UIFont.boldSystemFont(ofSize: 18.0)
        pagingViewController.font = UIFont.boldSystemFont(ofSize: 16.0)
        pagingViewController.menuItemSize = PagingMenuItemSize.sizeToFit(minWidth: 60, height: 40)

        addChildViewController(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParentViewController: self)
    
        navigationItem.titleView = pagingViewController.collectionView
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "开播", style: .plain, target: self, action: #selector(broadcastTapped))
        
        addCenterButton(withImage: UIImage(named: "camera")!, highlightImage: UIImage(named: "camera_sel")!)
        initOpenChat()
        
        LocationManager.share.startMonitor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AuthUtils.share.validate() == AuthType.UNAUTH {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: .plain, target: self, action: #selector(loginTapped))
        }else if AuthUtils.share.validate() == AuthType.EXPIRED{
            loginTapped()
        }else if AuthUtils.share.validate() == AuthType.LOGGED {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationItem.titleView?.frame = CGRect(origin: .zero, size: navigationBar.bounds.size)
    }
    
    func initOpenChat(){
        ChatManager.login { (user, error) in
            if(error != nil){
                print("SendBird Login Failed: \(String(describing: error?.localizedDescription))")
            }else{
                let userDefault: UserDefaults = UserDefaults.standard
                userDefault.set(SBDMain.getCurrentUser()?.userId, forKey: "sendbird_user_id")
                userDefault.set(SBDMain.getCurrentUser()?.nickname, forKey: "sendbird_user_nickname")
                userDefault.synchronize()
            }
        }
    }
    
    @objc func broadcastTapped(){
        if Utils.isNotNil(obj: AuthUtils.share.apiToken()) {
            if AuthUtils.share.isAnchor() {
                let broadcastVC = BroadcastVC()
                self.present(broadcastVC, animated: true, completion: nil)
            }else{
                let anchorFormVC = AnchorFormVC()
                self.present(anchorFormVC, animated: true, completion: nil)
            }
        }else{
            loginTapped()
        }
    }
    
    @objc func loginTapped(){
        let loginVC = LoginVC()
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func addCenterButton(withImage buttonImage : UIImage, highlightImage: UIImage) {
        let paddingBottom : CGFloat = Constants.Dimension.HOME_INDICATOR_HEIGHT
        let button = UIButton(type: .custom)
        button.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        button.frame = CGRect(x: 0.0, y: 0.0, width: 50, height: 32)
        button.setImage(buttonImage, for: .normal)
        button.setImage(highlightImage, for: .highlighted)
        button.subviews.first?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(MainVC.cameraBtnClicked(_:)), for: .touchUpInside)
        
        let rectBoundTabbar = self.tabBarController?.tabBar.bounds
        let xx = rectBoundTabbar?.midX
        let yy = (rectBoundTabbar?.midY)! - paddingBottom/2
        button.center = CGPoint(x: xx!, y: yy)

        self.tabBarController?.tabBar.addSubview(button)
        self.tabBarController?.tabBar.bringSubview(toFront: button)
        
        if let count = self.tabBarController?.tabBar.items?.count{
            let i = floor(Double(count / 2))
            let item = self.tabBarController?.tabBar.items![Int(i)]
            item?.title = ""
        }
        
        let gradientLayer : CAGradientLayer = Utils.makeGradientColor(for: button)
        gradientLayer.cornerRadius = 8
        button.layer.insertSublayer(gradientLayer, below: button.imageView?.layer)
    }
    
    @objc func cameraBtnClicked(_ sender: Any){
        if(AuthUtils.share.validate() == AuthType.LOGGED && Utils.isNotNil(obj: AuthUtils.share.apiToken())){
            let alertController = UIAlertController(title: nil, message: "Choose your content", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                
            }
            alertController.addAction(cancelAction)
            
            let textAction = UIAlertAction(title: "Post A Text", style: .default) { (action) in
                self.postType = .text
                self.goCreateMoment(withTLPHAssets: nil)
            }
            alertController.addAction(textAction)
            
            let momentAction = UIAlertAction(title: "Post Pictures", style: .default) { (action) in
                self.postType = .picture
                self.startImagePicker()
            }
            alertController.addAction(momentAction)
            
            let videoAction = UIAlertAction(title: "Post A Video", style: .default) { (action) in
                self.postType = .video
                let filterCameraVC = FilterCameraVC()
                self.present(filterCameraVC, animated: true, completion: nil)
            }
            alertController.addAction(videoAction)
            self.present(alertController, animated: true, completion: nil)
        }else {
            loginTapped()
        }
    }
    
    func startImagePicker() {
        let viewController = TLPhotosPickerViewController()
        viewController.delegate = self
        viewController.didExceedMaximumNumberOfSelection = { (picker) in
            let alert = UIAlertController(title: "Alert", message: "Exceed Maximum Number Of Selection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            picker.present(alert, animated: true, completion: nil)
        }
        var configure = TLPhotosPickerConfigure()
        configure.maxSelectedAssets = 9
        configure.allowedVideo = false
        configure.allowedVideoRecording = false
        viewController.configure = configure
        self.present(viewController, animated: true, completion: nil)
    }
    
    func goCreateMoment(withTLPHAssets: [TLPHAsset]?){
        let createMomentVC = CreateMomentVC()
        createMomentVC.postType = self.postType
        if withTLPHAssets != nil {
            createMomentVC.imageAssets = withTLPHAssets!
        }
        
        createMomentVC.completedBlock = { (moment) -> () in
            
            if moment != nil {
                self.momentVC.momentData.data.append(moment!)
                self.momentVC.tableView.reloadData()
            }
            
        }
        
        DispatchQueue.main.async {
            self.present(createMomentVC, animated: true, completion: nil)
        }
    }
    
}

extension MainVC: PagingViewControllerDelegate, TLPhotosPickerViewControllerDelegate{
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, widthForPagingItem pagingItem: T, isSelected: Bool) -> CGFloat? {
        guard let item = pagingItem as? PagingIndexItem else { return 0 }
        
        let insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: pagingViewController.menuItemSize.height)
        let attributes = [NSAttributedStringKey.font: pagingViewController.font]
        
        let rect = item.title.boundingRect(with: size,
                                           options: .usesLineFragmentOrigin,
                                           attributes: attributes,
                                           context: nil)
        
        let width = ceil(rect.width) + insets.left + insets.right
        
        if isSelected {
            return width * 1.5
        } else {
            return width
        }
    }
    
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        if self.postType == .video {
            
        }else{
            goCreateMoment(withTLPHAssets: withTLPHAssets)
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













