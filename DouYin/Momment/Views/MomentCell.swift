//
//  MomentCell.swift
//  DouYin
//
//  Created by Niu Changming on 8/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class MomentCell: UITableViewCell {
    
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
                    picIV.contentMode = .scaleAspectFill
                    self.picContainerView.addSubview(picIV)
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}















