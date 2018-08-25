//
//  ProfileVC.swift
//  DouYin
//
//  Created by Niu Changming on 31/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import Parchment

class ProfileVC: UITableViewController {
    
    let personData = PersonData()
    
    @IBOutlet weak var avatarIV: UIImageView! {
        didSet{
            avatarIV.clipsToBounds = true
            avatarIV.layer.cornerRadius = avatarIV.frame.size.width / 2
        }
    }
    @IBOutlet weak var followerAmountLbl: UILabel!
    @IBOutlet weak var followingAmountLbl: UILabel!
    
    @IBOutlet weak var genderLbl: UILabel!
    
    @IBOutlet weak var birthdayLbl: UILabel!
    
    @IBOutlet weak var regionLbl: UILabel!
    
    
    @IBOutlet weak var coinAmountLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!{
        didSet{
            editBtn.layer.cornerRadius = editBtn.frame.size.height / 2
            editBtn.clipsToBounds = true
            editBtn.layer.borderWidth = 2
            editBtn.layer.borderColor = UIColor(hexString: Constants.ColorScheme.greenColor).cgColor
        }
    }
    @IBOutlet weak var topupBtn: UIButton!{
        didSet{
            topupBtn.layer.cornerRadius = editBtn.frame.size.height / 2
            topupBtn.clipsToBounds = true
            let gradientLayer = Utils.makeGradientColor(for: topupBtn, startColor: UIColor(hexString: Constants.ColorScheme.orangeColor), endColor: UIColor(hexString: Constants.ColorScheme.redColor))
            topupBtn.layer.insertSublayer(gradientLayer, below: topupBtn.imageView?.layer)
        }
    }
    @IBOutlet weak var detailContainer: UIView!
    
    lazy var myVideoVC: MyVideoVC = {
        let myVideoVC = MyVideoVC()
        myVideoVC.title = "我的视频"
        return myVideoVC
    }()
    
    lazy var favoriteVideoVC: FavoriteVideoVC = {
        let favoriteVideoVC = FavoriteVideoVC()
        favoriteVideoVC.title = "收藏列表"
        return favoriteVideoVC
    }()
    
    lazy var momentVC: MyMomentVC = {
        let momentVC = MyMomentVC()
        momentVC.title = "我的图文"
        return momentVC
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        
        initDetailContainerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPersonalData()
    }
    
    func initDetailContainerView (){
        let momentVC: UIViewController = MyMomentVC()
        momentVC.title = "我的图文"
        
        let pagingViewController = FixedPagingViewController(viewControllers: [self.myVideoVC, self.favoriteVideoVC, self.momentVC])
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
        detailContainer.addSubview(pagingViewController.view)
        detailContainer.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParentViewController: self)
    }
    
    func loadPersonalData(){
        personData.getData { (status) in
            if status == .success {
                self.updateViews()
            }
        }
    }
    
    func updateViews(){
        self.followerAmountLbl.text = String(format: "%i", (self.personData.data?.followerAmount)!)
        self.followingAmountLbl.text = String(format: "%i", (self.personData.data?.followingAmount)!)
        
        if Utils.isNotNil(obj: self.personData.data?.name) {
            self.navigationItem.title = self.personData.data?.name
        }
        
        if Utils.isNotNil(obj: self.personData.data?.nickName) {
            self.navigationItem.title = self.personData.data?.nickName
        }
        
        self.genderLbl.text = self.personData.data?.gender == 0 ? "Male" : "Female"
        
        if (self.personData.data?.birthday)! > 0 {
            let birthdayDate = Date.init(millis: (self.personData.data?.birthday)!)
            self.birthdayLbl.text = birthdayDate.toDateStr()
        }
        
        if Utils.isNotNil(obj: self.personData.data?.region) {
            self.regionLbl.text = self.personData.data?.region
        }
        
        if Utils.isNotNil(obj: self.personData.data?.avatar) {
            avatarIV.sd_setImage(with: URL(string: (self.personData.data?.avatar?.origin)!), placeholderImage: UIImage(named: "placeholder.png"))
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    @IBAction func editBtnClicked(_ sender: UIButton){
        self.goPersonalVC()
    }
    
    @IBAction func topupBtnClicked(_ sender: UIButton){
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 120;
        }else if(indexPath.section == 1){
            return 60;
        }
        return tableView.frame.size.height - 180
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.goPersonalVC()
        }
    }
    
    func goPersonalVC(){
        if AuthUtils.share.validate() == AuthType.LOGGED && Utils.isNotNil(obj: AuthUtils.share.apiToken()) {
            let storyboard = UIStoryboard(name: "PersonalInfo", bundle: nil)
            let personalVC = storyboard.instantiateViewController(withIdentifier: "PersonalVC") as! PersonalVC
            personalVC.person = self.personData.data
            self.navigationController?.pushViewController(personalVC, animated: true)
        }else {
            let loginVC = LoginVC()
            self.present(loginVC, animated: true, completion: nil)
        }
    }

}

extension ProfileVC: PagingViewControllerDelegate {
    
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
    
}
