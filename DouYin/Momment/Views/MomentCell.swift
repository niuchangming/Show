//
//  MomentCell.swift
//  DouYin
//
//  Created by Niu Changming on 8/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import CoreData

class MomentCell: UITableViewCell, GiftViewDelegate {
    var moment: Moment?
    
    @IBOutlet weak var publishTimeLbl: UILabel!
    
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var avatarIV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var bodyLbl: UILabel!
    @IBOutlet weak var bodyLinkConstraint: NSLayoutConstraint!
    @IBOutlet weak var bodyPicContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var bodyBtnContainerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var linkPicContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var linkBtnContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var linkIconIV: UIImageView!
    @IBOutlet weak var linkTitleLbl: UILabel!
    
    @IBOutlet weak var picContainerView: UIView!
    @IBOutlet weak var picContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var picBtnContainerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnContainerView: UIView!
    @IBOutlet weak var btnCommentContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var awardBtn: UIButton!
    @IBOutlet weak var momentCommentBtn: UIButton!
    
    @IBOutlet weak var commentContainerView: UIView!
    @IBOutlet weak var commentContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentContainerBottomConstraint: NSLayoutConstraint!
    
    lazy var giftView: GiftView = {
        let giftView = GiftView(frame: CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT))
        giftView.delegate = self
        return giftView
    }()
    
    lazy var gifImageView: FLAnimatedImageView = {
        let gifImageView = FLAnimatedImageView(frame: CGRect(x: 7.5, y: 0, width: 360, height: 225))
        gifImageView.contentMode = .scaleAspectFill
        gifImageView.isHidden = true
        return gifImageView
    }()
    
    lazy var dataContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }()
    
    lazy var likeManagedObject: NSManagedObject = {
        let entity = NSEntityDescription.entity(forEntityName: "ResourceLikeMap", in: dataContext)
        let likeManagedObj = NSManagedObject(entity: entity!, insertInto: dataContext)
        return likeManagedObj
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        bodyLbl.numberOfLines = 0
        self.selectionStyle = .none
        
        self.commentContainerView.clipsToBounds = true
        self.commentContainerView.layer.cornerRadius = Constants.Dimension.CORNER_SIZE

        self.awardBtn.setImage(awardBtn.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.awardBtn.tintColor = UIColor(hexString: Constants.ColorScheme.orangeColor)
        
        self.momentCommentBtn.setImage(momentCommentBtn.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.momentCommentBtn.tintColor = UIColor(hexString: Constants.ColorScheme.blueColor)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configLikeBtnColor(){
        self.likeBtn.setImage(likeBtn.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.likeBtn.tintColor = UIColor(hexString: Constants.ColorScheme.redColor)
    }

    func updateUI(moment: Moment){
        self.moment = moment
        if let avarar = moment.creator.avatar {
            self.avatarIV.sd_setImage(with: URL(string: avarar.origin), placeholderImage: UIImage(named: "placeholder.png"))
        }
        
        self.nameLbl.text = moment.creator.name
        self.bodyLbl.text = moment.body
        self.likeCountLbl.text = String(moment.likeCount)
        self.publishTimeLbl.text = Date(timeIntervalSince1970: TimeInterval(moment.uploadTime / 1000)).getElapsedInterval()
        self.likeCountLbl.text = String(moment.likeCount)
        
        if fetchMomentLike() > 0 {
            self.likeBtn.tag = 1
            self.likeBtn.setImage(UIImage(named: "heart"), for: .normal)
        }else{
            self.likeBtn.tag = 0
            self.likeBtn.setImage(UIImage(named: "heart_line"), for: .normal)
        }
        configLikeBtnColor()
    
        if(moment.comments.count > 0){ //有comment
            for view in self.commentContainerView.subviews {
                view .removeFromSuperview()
            }
            self.commentContainerView.isHidden = false
            let commentRowHeight: CGFloat = 30.0
            let padding: CGFloat = Constants.Dimension.MARGIN_SMALL
            let comments: [Comment] = filterComment(moment: self.moment!)
            let commentContainerHeight = CGFloat(comments.count) * commentRowHeight + 2 * padding

            for i in 0..<comments.count {
                let comment: Comment = moment.comments[i]
                let commentLblBtn: UIButton = UIButton(frame: CGRect(x: padding, y: padding + CGFloat(i) * commentRowHeight, width: commentContainerView.frame.size.width * Constants.Dimension.W_RATIO - 2 * padding, height: commentRowHeight))

                commentLblBtn.titleLabel?.numberOfLines = 0
                commentLblBtn.titleLabel?.font = UIFont.systemFont(ofSize: Constants.Dimension.TEXT_SIZE_SMALL)
                commentLblBtn.titleLabel?.textColor = UIColor(hexString: Constants.ColorScheme.blackColor)
                commentLblBtn.setBackgroundColor(color: UIColor(hexString: Constants.ColorScheme.lightGrayColor), forState: .highlighted)
                commentLblBtn.contentHorizontalAlignment = .left
                
                let commentStr: String = String(format: "%@: %@", (comment.creator?.name)!, comment.body)
                let range = (commentStr as NSString).range(of: String(format: "%@", (comment.creator?.name)!))
                let attribute = NSMutableAttributedString(string: commentStr)
                attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(hexString: Constants.ColorScheme.blueColor), range: range)
                
                commentLblBtn.setAttributedTitle(attribute, for: .normal)
                commentLblBtn.addTarget(self, action: #selector(MomentCell.commentBtnClicked(_:)), for: .touchUpInside)
                commentLblBtn.layer.setValue(comment, forKey: "comment")
                commentContainerView.addSubview(commentLblBtn)
            }

            self.commentContainerHeightConstraint.constant = commentContainerHeight
            self.commentContainerHeightConstraint.priority = UILayoutPriority(rawValue: 999)
            self.commentContainerBottomConstraint.constant = Constants.Dimension.MARGIN_MIDDLE
            self.commentContainerBottomConstraint.priority = UILayoutPriority(rawValue: 999)
        }else{ //无comment
            self.commentContainerView.isHidden = true
            self.commentContainerHeightConstraint.constant = 0
            self.commentContainerBottomConstraint.constant = 0
            self.commentContainerBottomConstraint.priority = UILayoutPriority(rawValue: 999)
        }
        self.btnCommentContainerConstraint.constant = Constants.Dimension.MARGIN_MIDDLE
        self.btnCommentContainerConstraint.priority = UILayoutPriority(rawValue: 999)
        self.btnContainerBottomConstraint.priority = UILayoutPriority(rawValue: 750)

        if(moment.type == "link"){
            self.linkView.isHidden = false
            self.picContainerView.isHidden = true
//            self.linkIconIV.sd_setImage(with: URL(string: (moment.link?.icon)!), placeholderImage: UIImage(named: "placeholder.png"))
//            self.linkTitleLbl.text = moment.link?.title

            self.bodyLinkConstraint.constant = Constants.Dimension.MARGIN_NOR
            self.bodyLinkConstraint.priority = UILayoutPriority(rawValue: 999)
            self.bodyPicContainerConstraint.priority = UILayoutPriority(rawValue: 750)
            self.bodyBtnContainerConstraint.priority = UILayoutPriority(rawValue: 750)

            self.linkBtnContainerConstraint.constant = Constants.Dimension.MARGIN_NOR
            self.linkBtnContainerConstraint.priority = UILayoutPriority(rawValue: 999)
            self.linkPicContainerConstraint.priority = UILayoutPriority(rawValue: 750)
        }else if(moment.type == "picture"){
            for view in self.picContainerView.subviews {
                view .removeFromSuperview()
            }
            
            self.picContainerView.isHidden = false
            self.linkView.isHidden = true

            let picWidth: CGFloat = 80 * Constants.Dimension.W_RATIO
            let picHeight: CGFloat = picWidth
            let colCount = 3
            var rowCount = moment.photoArray.count / colCount + 1
            if(moment.photoArray.count % colCount == 0){
                rowCount = rowCount - 1
            }

            for r in 0..<rowCount{
                for c in 0..<3{
                    let index = 3*r+c
                    if(index == moment.photoArray.count){
                        break;
                    }

                    let picIV = UIImageView(frame: CGRect(x: CGFloat(1 + c)*Constants.Dimension.MARGIN_SMALL + CGFloat(c) * picWidth,
                                                          y: CGFloat(r)*picHeight + CGFloat(1 + r)*Constants.Dimension.MARGIN_SMALL,
                                                          width: picWidth,
                                                          height: picHeight))
                    picIV.sd_setImage(with: URL(string: moment.photoArray[index].origin), placeholderImage: UIImage(named: "placeholder.png"))
                    picIV.clipsToBounds = true
                    picIV.tag = index
                    picIV.contentMode = .scaleAspectFill
                    self.picContainerView.addSubview(picIV)

                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                    picIV.isUserInteractionEnabled = true
                    picIV.addGestureRecognizer(tapGestureRecognizer)
                }
            }

            self.bodyPicContainerConstraint.constant = Constants.Dimension.MARGIN_NOR
            self.bodyPicContainerConstraint.priority = UILayoutPriority(rawValue: 999)
            self.bodyLinkConstraint.priority = UILayoutPriority(rawValue: 750)
            self.bodyBtnContainerConstraint.priority = UILayoutPriority(rawValue: 750)

            self.picContainerHeightConstraint.constant = CGFloat(rowCount) * picHeight + Constants.Dimension.MARGIN_SMALL * CGFloat(rowCount + 1)
            self.picBtnContainerConstraint.constant = Constants.Dimension.MARGIN_NOR
            self.picBtnContainerConstraint.priority = UILayoutPriority(rawValue: 999)

            self.linkPicContainerConstraint.priority = UILayoutPriority(rawValue: 750)
            self.linkBtnContainerConstraint.priority = UILayoutPriority(rawValue: 750)
        }else{
            self.linkView.isHidden = true
            self.picContainerView.isHidden = true
            self.bodyBtnContainerConstraint.constant = Constants.Dimension.MARGIN_NOR
            self.bodyBtnContainerConstraint.priority = UILayoutPriority(rawValue: 999)

            self.bodyLinkConstraint.priority = UILayoutPriority(rawValue: 750)
            self.bodyPicContainerConstraint.priority = UILayoutPriority(rawValue: 750)
        }
    }
    
    func filterComment(moment: Moment) -> [Comment]{
        var comments: [Comment] = []
        for comment in moment.comments {
            comments = gatherComment(comment: comment, comments: comments)
        }
        
        return comments
    }
    
    func gatherComment(comment: Comment, comments: [Comment]) -> [Comment] {
        var copyComments = comments
        
        if comment.comments.count > 0 {
            for comment in comment.comments {
                if comment.comments.count > 0 {
                    copyComments = gatherComment(comment: comment, comments: copyComments)
                }
                copyComments.append(comment)
            }
        }else{
            copyComments.append(comment)
        }
        return copyComments
    }
    
    @objc func commentBtnClicked(_ sender: UIButton){
        let momentVC: MomentVC = Utils.viewController(responder: self) as! MomentVC
        if AuthUtils.share.validate() == .LOGGED && Utils.isNotNil(obj: AuthUtils.share.apiToken()) {
            let comment = sender.layer.value(forKey: "comment") as? Comment
            
            if comment != nil {
                momentVC.tmpObject = comment
                momentVC.chatInputBar.messageInputTv.becomeFirstResponder()
            }
        }else{
            let loginVC = LoginVC()
            momentVC.present(loginVC, animated: true, completion: nil)
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)  {
        let tappedImageView = tapGestureRecognizer.view as! UIImageView
        
        var photoImages: [ViewerImageProtocol] = []
        for view in self.picContainerView.subviews{
            if(view.isKind(of: UIImageView.self)){
                let imv = view as! UIImageView
                let appImage = ViewerImage.appImage(forImage: imv.image!)
                photoImages.append(appImage)
            }
        }

        let viewer = AppImageViewer(originImage: tappedImageView.image!, photos: photoImages, animatedFromView: tappedImageView)
        viewer.currentPageIndex = tappedImageView.tag
        let relatedVC = Utils.viewController(responder: tappedImageView)
        relatedVC?.present(viewer, animated: true, completion: nil)
    }
    
    @IBAction func momentCommentBtnClicked(_ sender: UIButton) {
        let momentVC: MomentVC = Utils.viewController(responder: self) as! MomentVC
        if AuthUtils.share.validate() == .LOGGED && Utils.isNotNil(obj: AuthUtils.share.apiToken()) {
            momentVC.tmpObject = self.moment
            momentVC.chatInputBar.messageInputTv.becomeFirstResponder()
        }else{
            let loginVC = LoginVC()
            momentVC.present(loginVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func likeBtnClicked(_ sender: UIButton) {
        if sender.tag == 1 {
            unlike()
        }else{
            like()
        }
    }
    
    @IBAction func awardBtnClicked(_ sender: UIButton){
        let giftData: GiftData =  GiftData()
        
        giftData.getData { [unowned self] (message) in
            if message == "Success" {
                self.giftView.giftArray = giftData.data
                self.giftView.show()
                self.giftView.collectionView.reloadData()
            }
        }
    }
    
    func like(){
        likeBtn.isEnabled = false
        let likeAPI = String(format: "%@likes/like", Constants.HOST)
        ConnectionManager.shareManager.request(method: .post, url: likeAPI, parames: ["resourceId": moment?.momentId, "token": AuthUtils.share.apiToken()] as [String: AnyObject], succeed: { (responseJson) in
            
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            let message = response["message"] as! String
            if errorCode == 1 {
                self.likeBtn.setImage(UIImage(named: "heart"), for: .normal)
                self.configLikeBtnColor()
                self.save()
            } else {
                print("Like Error: \(message)")
            }
            self.likeBtn.isEnabled = true
        }) { (error) in
            print("Like Error: \(String(describing: error?.localizedDescription))")
            self.likeBtn.isEnabled = true
        }
    }
    
    func unlike(){
        likeBtn.isEnabled = false
        let likeAPI = String(format: "%@likes/unlike", Constants.HOST)
        ConnectionManager.shareManager.request(method: .post, url: likeAPI, parames: ["resourceId": moment?.momentId, "token": AuthUtils.share.apiToken()] as [String: AnyObject], succeed: { (responseJson) in
            
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            let message = response["message"] as! String
            if errorCode == 1 {
                self.likeBtn.setImage(UIImage(named: "heart_line"), for: .normal)
                self.configLikeBtnColor()
                self.delete()
            } else {
                print("Unlike Error: \(message)")
            }
            self.likeBtn.isEnabled = true
        }) { (error) in
            print("Unlike Error: \(String(describing: error?.localizedDescription))")
            self.likeBtn.isEnabled = true
        }
    }
    
    func save(){
        guard let m = moment else { return }
        
        self.likeManagedObject.setValue(m.momentId, forKey: "resourceId")
        self.likeManagedObject.setValue(m.likeCount+1, forKey: "likeCount")
        
        do {
            try dataContext.save()
        } catch {
            print("Failed Save Moment Like")
        }
    }
    
    func delete() {
        guard let m = moment else { return }
        
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ResourceLikeMap")
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "resourceId = %@", m.momentId)
            request.returnsObjectsAsFaults = false
            
            let fetchResult = try dataContext.fetch(request)
            let likeObj = fetchResult.first as! NSManagedObject
            
            dataContext.delete(likeObj)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.saveContext()
        } catch {
            print("Failed Delete Moment Like")
        }
    }
    
    func fetchMomentLike() -> Int32{
        guard let m = moment else { return 0 }
        
        var likeCount: Int32 = 0
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ResourceLikeMap")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "resourceId = %@", m.momentId)
        request.returnsObjectsAsFaults = false
    
        do {
            let result = try dataContext.fetch(request)
            
            if result.count == 1 {
                let likeObj = result.first as! NSManagedObject
                likeCount = likeObj.value(forKey: "likeCount") as! Int32
            }
        } catch {
            print("Fetch Moment Like Failed")
        }
        return likeCount
    }
    
    @objc func alertControllerBackgroundTapped(){
        let momentVC: MomentVC = Utils.viewController(responder: self) as! MomentVC
        momentVC.dismiss(animated: true, completion: nil)
    }
    
    func giftViewSendGiftInView(giftView: GiftView, gift: Gift?) {
        let momentVC: MomentVC = Utils.viewController(responder: self) as! MomentVC
        if(gift == nil){
            let alertController = UIAlertController(title: "发送失败", message: "抱歉，您还没有哦选择礼物！", preferredStyle: .alert)
            let actionKnown = UIAlertAction(title: "知道了", style: .cancel) { (action:UIAlertAction) in}
            alertController.addAction(actionKnown)
            momentVC.present(alertController, animated: true, completion: {
                self.giftView.hide()
            })
        }else{
            let giftSend: GiftSend = GiftSend()
            giftSend.icon = (gift?.image)!
            giftSend.name = (gift?.name)!
            giftSend.icon_gif = (gift?.animImage)!
            giftSend.id = (gift?.id)!;
            giftSend.defaultCount = 0;
            giftSend.sendCount = 1;
        
            GiftShowManager.shared().showGiftViewWithBackView(backView: momentVC.view, giftSend: giftSend, completeBlock: { (finished: Bool) in
            
            }, showGifImageBlock: { (giftSend: GiftSend) in
            
                DispatchQueue.main.async {
                    let window: UIWindow = UIApplication.shared.keyWindow!
                    window.addSubview(self.gifImageView)
                    
                    do{
                        let gifData = try Data.init(contentsOf: URL(string: (gift?.animImage)!)!)
                        let gifImage: FLAnimatedImage = FLAnimatedImage(animatedGIFData: gifData)
                        self.gifImageView.animatedImage = gifImage
                        self.gifImageView.isHidden = false
                    }catch {
                        print("Donwload Gif Image failed")
                    }

                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2), execute: { () in
                        self.gifImageView.isHidden = true
                        self.gifImageView.removeFromSuperview()
                    })
                    
                }
                
            })
            
        }
    }
    
}
















