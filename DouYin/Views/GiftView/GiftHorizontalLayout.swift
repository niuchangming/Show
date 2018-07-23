//
//  GiftHorizontalLayout.swift
//  DouYin
//
//  Created by Niu Changming on 14/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class GiftHorizontalLayout: UICollectionViewFlowLayout {
    
    var cellAttributesArray: Array<UICollectionViewLayoutAttributes> = []
    var layoutContentSize: CGSize!
    
    override init() {
        super.init()
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        self.scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        let itemWidth: CGFloat = Constants.Dimension.SCREEN_WIDTH / 4
        let itemHeight: CGFloat = itemWidth * 105 / 93.8

        self.cellAttributesArray.removeAll()
        
        var contentSizeHeight: CGFloat = 0
        let cellCount: Int = (self.collectionView?.numberOfItems(inSection: 0))!
        let page: Int = cellCount / 8 + 1;
        for i in 0..<cellCount {
            let indexPath: IndexPath = IndexPath(row: i, section: 0)
            let attibute: UICollectionViewLayoutAttributes = self.layoutAttributesForItem(at: indexPath)!
            let page: Int = i / 8
            let row: Int = i % 4 + page * 4
            let col: Int = i / 4 - page * 2
            attibute.frame = CGRect(x: CGFloat(row) * itemWidth, y: CGFloat(col) * itemHeight, width: itemWidth, height: itemHeight)
            self.cellAttributesArray.append(attibute)
            
            contentSizeHeight = max(attibute.frame.maxY, contentSizeHeight)
        }
        
        layoutContentSize = CGSize(width: CGFloat(page) * Constants.Dimension.SCREEN_WIDTH, height: contentSizeHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.cellAttributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as! UICollectionViewLayoutAttributes
        return attributes
    }
    
    override var collectionViewContentSize: CGSize {
        return layoutContentSize
    }
    
}
