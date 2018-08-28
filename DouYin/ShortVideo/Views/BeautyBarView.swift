//
//  BeautyBarView.swift
//  DouYin
//
//  Created by Niu Changming on 13/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import GPUImage

protocol BeautyBarDelegate: class {
    func beautyCellDidClicked(filterOperation: FilterOperationInterface)
}

class BeautyBarView: ReusableViewFromXib {
    @IBOutlet weak var collectionView: UICollectionView!
    var delegate: BeautyBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.customView?.backgroundColor = .clear
        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0)
        flow.itemSize = CGSize(width: 50, height: 70)
        flow.scrollDirection = .horizontal
        
        collectionView.register(CircleCell.nib(), forCellWithReuseIdentifier: CircleCell.cellReuseIdentifier())
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

extension BeautyBarView: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterOperations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleCell.cellReuseIdentifier(), for: indexPath) as! CircleCell
        
        let filter = filterOperations[indexPath.row]
        
        cell.iconIv.image = UIImage.init(named: filter.listName)
        cell.nameLbl.text = filter.titleName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentFilter = filterOperations[indexPath.row]
        self.delegate?.beautyCellDidClicked(filterOperation: currentFilter)
    }
    
}
