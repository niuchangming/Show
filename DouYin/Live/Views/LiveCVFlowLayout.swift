//
//  LiveCVFlowLayout.swift
//  DouYin
//
//  Created by Niu Changming on 29/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class LiveCVFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        self.scrollDirection = UICollectionViewScrollDirection.vertical
        self.itemSize = (self.collectionView?.bounds.size)!
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
    }
}
