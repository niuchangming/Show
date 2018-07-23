//
//  MomentCell.swift
//  DouYin
//
//  Created by Niu Changming on 8/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class MomentCell: UITableViewCell, GiftViewDelegate {
    var moment: Moment?
    
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
    @IBOutlet weak var commentBtn: UIButton!
    
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
        gifImageView.isHidden = true
        return gifImageView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        bodyLbl.numberOfLines = 0
        self.selectionStyle = .none
        
        self.commentContainerView.clipsToBounds = true
        self.commentContainerView.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        
        self.likeBtn.setImage(likeBtn.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.likeBtn.tintColor = UIColor(hexString: Constants.ColorScheme.redColor)

        self.awardBtn.setImage(awardBtn.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.awardBtn.tintColor = UIColor(hexString: Constants.ColorScheme.orangeColor)
        
        self.commentBtn.setImage(commentBtn.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.commentBtn.tintColor = UIColor(hexString: Constants.ColorScheme.blueColor)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func updateUI(moment: Moment){
        self.moment = moment
        self.avatarIV.sd_setImage(with: URL(string: moment.avatarLink), placeholderImage: UIImage(named: "placeholder.png"))
        self.nameLbl.text = moment.author
        self.bodyLbl.text = moment.body
        
        if(moment.comments != nil && (moment.comments?.count)! > 0){ //有comment
            self.commentContainerView.isHidden = false
            let commentRowHeight: CGFloat = 30.0
            let padding: CGFloat = Constants.Dimension.MARGIN_SMALL
            let commentContainerHeight = CGFloat((moment.comments?.count)!) * commentRowHeight + 2 * padding
            
            if let commentList = moment.comments {
                for i in 0..<commentList.count {
                    let comment: Comment = commentList[i]
                    let commentLbl: UILabel = UILabel(frame: CGRect(x: padding, y: padding + CGFloat(i) * commentRowHeight, width: commentContainerView.frame.size.width * Constants.Dimension.W_RATIO - 2 * padding, height: commentRowHeight))
                    commentLbl.numberOfLines = 0
                    commentLbl.font = UIFont.systemFont(ofSize: Constants.Dimension.TEXT_SIZE_SMALL)
                    commentLbl.textColor = UIColor(hexString: Constants.ColorScheme.blackColor)
                    let commentStr: String = String(format: "%@: %@", comment.author, comment.content)
                    let range = (commentStr as NSString).range(of: String(format: "%@", comment.author))
                    let attribute = NSMutableAttributedString(string: commentStr)
                    attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(hexString: Constants.ColorScheme.blueColor), range: range)
                    commentLbl.attributedText = attribute
                    commentContainerView.addSubview(commentLbl)
                }
            }
            
            self.commentContainerHeightConstraint.constant = commentContainerHeight
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
        
        if(moment.type == 1){
            self.linkView.isHidden = false
            self.picContainerView.isHidden = true
            self.linkIconIV.sd_setImage(with: URL(string: (moment.link?.icon)!), placeholderImage: UIImage(named: "placeholder.png"))
            self.linkTitleLbl.text = moment.link?.title
            
            self.bodyLinkConstraint.constant = Constants.Dimension.MARGIN_NOR
            self.bodyLinkConstraint.priority = UILayoutPriority(rawValue: 999)
            self.bodyPicContainerConstraint.priority = UILayoutPriority(rawValue: 750)
            self.bodyBtnContainerConstraint.priority = UILayoutPriority(rawValue: 750)
            
            self.linkBtnContainerConstraint.constant = Constants.Dimension.MARGIN_NOR
            self.linkBtnContainerConstraint.priority = UILayoutPriority(rawValue: 999)
            self.linkPicContainerConstraint.priority = UILayoutPriority(rawValue: 750)
        }else if(moment.type == 2){
            self.picContainerView.isHidden = false
            self.linkView.isHidden = true
            
            let picWidth: CGFloat = 80 * Constants.Dimension.W_RATIO
            let picHeight: CGFloat = picWidth
            let colCount = 3
            let rowCount = moment.pictures.count / colCount + 1
            
            for r in 0..<rowCount{
                for c in 0..<3{
                    let index = 3*r+c
                    if(index == moment.pictures.count){
                        break;
                    }
                    
                    let picIV = UIImageView(frame: CGRect(x: CGFloat(1 + c)*Constants.Dimension.MARGIN_SMALL + CGFloat(c) * picWidth,
                                                          y: CGFloat(r)*picHeight + CGFloat(1 + r)*Constants.Dimension.MARGIN_SMALL,
                                                          width: picWidth,
                                                          height: picHeight))
                    picIV.sd_setImage(with: URL(string: moment.pictures[index]), placeholderImage: UIImage(named: "placeholder.png"))
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
    
    @IBAction func commentBtnClicked(_ sender: UIButton) {
        let momentVC: MomentVC = Utils.viewController(responder: self) as! MomentVC
        momentVC.commentBar.commentTF.becomeFirstResponder()
    }
    
    @IBAction func likeBtnClicked(_ sender: UIButton) {
        
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
            giftSend.icon = (gift?.icon)!
            giftSend.username = (gift?.username)!
            giftSend.name = (gift?.name)!
            giftSend.icon_gif = (gift?.icon_gif)!
            giftSend.id = (gift?.id)!;
            giftSend.defaultCount = 0;
            giftSend.sendCount = 1;
        
            GiftShowManager.shared().showGiftViewWithBackView(backView: momentVC.view, giftSend: giftSend, completeBlock: { (finished: Bool) in
                
            }, showGifImageBlock: { (giftSend: GiftSend) in
            
                DispatchQueue.main.async {
                    let window: UIWindow = UIApplication.shared.keyWindow!
                    window.addSubview(self.gifImageView)
                    
                    if let asset = NSDataAsset(name: "live_yanhua") {
                        let data = asset.data
                        let gifImage: FLAnimatedImage = FLAnimatedImage(animatedGIFData: data)
                        self.gifImageView.animatedImage = gifImage
                        self.gifImageView.isHidden = false
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















