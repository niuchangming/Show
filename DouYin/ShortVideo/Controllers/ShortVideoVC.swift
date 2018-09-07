//
//  ViewController.swift
//  DouYin
//
//  Created by Niu Changming on 12/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import SDWebImage

class ShortVideoVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let videoData = VideoData();
    
    lazy var refreshCtrl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(hexString: Constants.ColorScheme.blackColor)
        refreshControl.addTarget(self, action:
            #selector(ShortVideoVC.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemSpacing: CGFloat = 2
        let itemsInOneLine: CGFloat = 2
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        let width = (UIScreen.main.bounds.size.width - itemSpacing * CGFloat(itemsInOneLine - 1)) / itemsInOneLine
        flow.itemSize = CGSize(width: floor(width), height: floor(4*width/3))
        flow.minimumInteritemSpacing = 2
        flow.minimumLineSpacing = 2
        
        collectionView.addSubview(refreshCtrl)
        
        loadData()
    }
    
    func loadData(){
        videoData.getData { [unowned self] (status) in
            if status == .success {
                self.collectionView.reloadData()
            }
            self.refreshCtrl.endRefreshing()
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        videoData.isFinished = false
        videoData.requiredTime = Date()
        videoData.data.removeAll()
        collectionView.reloadData()
        
        loadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoData.data.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkCollectionCell", for: indexPath) as! VideoCollectionCell
        
        let video: Video = videoData.data[indexPath.row]
        
        cell.usernameLbl.text = video.creator?.name
        
        if let preview = video.preview {
            cell.coverIV.sd_setImage(with: URL(string: preview.origin), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            cell.coverIV.image = UIImage(named: "placeholder.png")
        }
    
        cell.distanceLbl.text = "> 3Km"
        if let avatar = video.creator?.avatar {
            cell.userPhotoIV.sd_setImage(with: URL(string: avatar.origin), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            cell.userPhotoIV.image = UIImage(named: "placeholder.png")
        }
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let workDetailVC = VideoDetailVC()
        workDetailVC.videos = videoData.data
        workDetailVC.currentIndex = indexPath.row
        self.present(workDetailVC, animated: true, completion: nil)
    }

}

























