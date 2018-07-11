//
//  LiveVC.swift
//  DouYin
//
//  Created by Niu Changming on 26/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class LiveVC: UIViewController {

    var live :Live?
    var currentIndex : Int = 0
    let cellID: String = "LiveCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: Constants.ColorScheme.blackColor)
        self.collectionView.reloadData()
    }
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: LiveCVFlowLayout.init())
        if #available(iOS 11.0, *) {
            collection.contentInsetAdjustmentBehavior = .never
        }
        collection.register(LiveCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collection.delegate = self
        collection.dataSource = self
        
        self.view.addSubview(collection)
        
        collection.backgroundColor = UIColor.clear
        return collection
    }()
}

extension LiveVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! LiveCollectionViewCell
        cell.controller = self
        cell.liveData = self.live!
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        CFRunLoopWakeUp(CFRunLoopGetCurrent());
    }
    
}









