//
//  GiftView.swift
//  DouYin
//
//  Created by Niu Changming on 14/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

protocol GiftViewDelegate: class {
    func giftViewSendGiftInView(giftView: GiftView, gift: Gift?)
}

class GiftView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    let cellID = "GiftCollectionViewCell";
    var previousGift: Gift?
    weak var delegate: GiftViewDelegate?
    
    public var giftArray: [Gift] = []{
        didSet {
            self.pageControl.numberOfPages = giftArray.count/8+1;
            self.pageControl.currentPage = 0;
            self.pageControl.isHidden = (giftArray.count/8) <= 1
            self.collectionView.reloadData()
        }
    }
    
    lazy var bottomView: UIView = {
        let bottomMargin:CGFloat = 44 + Constants.Dimension.HOME_INDICATOR_HEIGHT
        let bottomView = UIView(frame: CGRect(x: 0, y: self.frame.size.height-bottomMargin, width: self.frame.size.width, height: bottomMargin))
        bottomView.backgroundColor = .clear
        bottomView.addSubview(self.pageControl)
        bottomView.addSubview(self.topupBtn)
        bottomView.addSubview(self.cbImageView)
        bottomView.addSubview(self.moneyLbl)
        bottomView.addSubview(self.sendBtn)
        self.addSubview(bottomView)
        return bottomView
    }()
    
    lazy var pageControl: UIPageControl = {
        let bottomMargin:CGFloat = 44 + Constants.Dimension.HOME_INDICATOR_HEIGHT
        let pageControl = UIPageControl(frame: CGRect(x: self.frame.size.width / 2 - 15, y:0, width: 30, height: bottomMargin))
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor(hexString: Constants.ColorScheme.grayColor)
        pageControl.isHidden = true
        return pageControl
    }()
    
    lazy var topupBtn: UIButton = {
        let topupBtn = UIButton(frame: CGRect(x: 5, y: 12, width: 30, height: 20))
        topupBtn.setTitle("充值", for: .normal)
        topupBtn.setTitleColor(UIColor.white, for: .normal)
        topupBtn.backgroundColor = UIColor.purple
        topupBtn.titleLabel?.font = UIFont.systemFont(ofSize: Constants.Dimension.TEXT_SIZE_EXTRA_SMALL)
        topupBtn.addTarget(self, action: #selector(topupBtnClicked(_:)), for: .touchUpInside)
        return topupBtn
    }()
    
    lazy var cbImageView: UIImageView = {
        let cbImageView = UIImageView(frame: CGRect(x: self.topupBtn.frame.maxX + Constants.Dimension.MARGIN_SMALL, y: self.topupBtn.frame.minY, width: 20, height: 20))
        cbImageView.image = UIImage(named: "live_cb")
        return cbImageView
    }()
    
    lazy var moneyLbl: UILabel = {
        let moneyLbl = UILabel(frame: CGRect(x: self.cbImageView.frame.maxX + Constants.Dimension.MARGIN_SMALL, y: self.cbImageView.frame.minY, width: 100, height: 20))
        moneyLbl.text = "999"
        moneyLbl.textColor = UIColor.white
        moneyLbl.font = UIFont.systemFont(ofSize: Constants.Dimension.TEXT_SIZE_SMALL)
        return moneyLbl
    }()
    
    lazy var sendBtn: UIButton = {
        let sendBtn = UIButton(frame: CGRect(x: self.frame.size.width - 60, y: 2, width: 60, height: 40))
        sendBtn.backgroundColor = UIColor(hexString: Constants.ColorScheme.orangeColor)
        sendBtn.setTitle("发送", for: .normal)
        sendBtn.setTitleColor(UIColor.white, for: .normal)
        sendBtn.titleLabel?.font = UIFont.systemFont(ofSize: Constants.Dimension.MARGIN_NOR)
        sendBtn.addTarget(self, action: #selector(sendBtnClicked(_:)), for: .touchUpInside)
        return sendBtn
    }()
    
    lazy var collectionView: UICollectionView = {
        let itemWidth: CGFloat = Constants.Dimension.SCREEN_WIDTH/4.0;
        let itemHeight: CGFloat = itemWidth * 25/22.0;
    
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 50, height: 50)
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: self.bottomView.frame.origin.y-2*itemHeight-1, width: Constants.Dimension.SCREEN_WIDTH, height: 2*itemHeight), collectionViewLayout: GiftHorizontalLayout())
        collectionView.backgroundColor = .clear
        collectionView.alpha = 0.9
        collectionView.register(GiftCollectionViewCell.self, forCellWithReuseIdentifier: self.cellID)
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        
        let separateLine = UIView(frame: CGRect(x: 0, y: self.bottomView.frame.origin.y-1, width: Constants.Dimension.SCREEN_WIDTH, height: 1))
        separateLine.backgroundColor = UIColor.white
        
        self.addSubview(separateLine)
        self.addSubview(collectionView)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    func initUI(){
        let itemWidth: CGFloat = Constants.Dimension.SCREEN_WIDTH/4.0;
        let itemHeight: CGFloat = itemWidth * 25/22.0;
        let bgHeight = Constants.Dimension.HOME_INDICATOR_HEIGHT + 44 + 2 * itemHeight + 1
        
        let bgView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - bgHeight, width: self.frame.size.width, height: bgHeight))
        bgView.backgroundColor = UIColor(hexString: Constants.ColorScheme.blackColor)
        bgView.alpha = 0.8
        self.addSubview(bgView)
    
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func show(){
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        self.backgroundColor = UIColor.clear
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.frame = CGRect(x: 0, y: 0, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
        })
    }
    
    func hide(){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.frame = CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
        })
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.frame = CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
        }) { (finished: Bool) in
            self.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hide()
    }


    @objc func topupBtnClicked(_ sender: UIButton){
        
    }
    
    @objc func sendBtnClicked(_ sender: UIButton){
        var selectedGift: Gift?
        for gift in self.giftArray {
            if(gift.isSelected){
                selectedGift = gift
                break;
            }
        }
        self.delegate?.giftViewSendGiftInView(giftView: self, gift: selectedGift)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x: CGFloat = scrollView.contentOffset.x;
        self.pageControl.currentPage = Int(x/Constants.Dimension.SCREEN_WIDTH + 0.5);
    }
}

extension GiftView{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.giftArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! GiftCollectionViewCell
        
        if(indexPath.item < self.giftArray.count){
            let gift: Gift = self.giftArray[indexPath.item]
            cell.gift = gift
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.item < self.giftArray.count) {
            let gift: Gift = self.giftArray[indexPath.item];
            gift.isSelected = !gift.isSelected;
            if (self.previousGift === gift) {
                self.collectionView.reloadData()
            }else {
                self.previousGift?.isSelected = false;
                UIView.performWithoutAnimation {
                    self.collectionView.reloadSections(IndexSet(integer: indexPath.section))
                }
            }
            self.previousGift = gift
        }
    }
}












