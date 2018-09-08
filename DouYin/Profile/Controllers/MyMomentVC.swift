//
//  MyMomentVC.swift
//  DouYin
//
//  Created by Niu Changming on 2/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class MyMomentVC: UIViewController {
    
    let momentData = MomentData()
    @IBOutlet weak var momentTV: UITableView!{
        didSet{
            momentTV.tableFooterView = UIView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.momentTV.register(LinkMomentCell.nib(), forCellReuseIdentifier: LinkMomentCell.cellReuseIdentifier())
        self.momentTV.register(TextMomentCell.nib(), forCellReuseIdentifier: TextMomentCell.cellReuseIdentifier())
        self.momentTV.register(ImageMomentCell.nib(), forCellReuseIdentifier: ImageMomentCell.cellReuseIdentifier())
        
        momentData.getPersonData { (status) in
            if status == .success {
                self.momentTV.reloadData()
            }
        }
    }
}

extension MyMomentVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.momentData.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        let moment = self.momentData.data[indexPath.row]
        if moment.type == "text" {
            cell = tableView.dequeueReusableCell(withIdentifier: TextMomentCell.cellReuseIdentifier(), for: indexPath) as! TextMomentCell
            
            (cell as! TextMomentCell).messageLbl.text = moment.body
            
            let labelHeight = (cell as! TextMomentCell).messageLbl.heightForLabel(text: moment.body, font: (cell as! TextMomentCell).messageLbl.font, width: (cell as! TextMomentCell).messageLbl.font.pointSize)
            if(labelHeight > 60){
                (cell as! TextMomentCell).messageLblConstrants.constant = 60
            }
        
        } else if moment.type == "link" {
             cell = tableView.dequeueReusableCell(withIdentifier: LinkMomentCell.cellReuseIdentifier(), for: indexPath) as! LinkMomentCell
            
//            (cell as! LinkMomentCell).messageLbl.text = moment.body
//            (cell as! LinkMomentCell).linkTitleLbl.text = moment.link?.title
//
//            let labelHeight = (cell as! LinkMomentCell).linkTitleLbl.heightForLabel(text: moment.body, font: (cell as! LinkMomentCell).linkTitleLbl.font, width: (cell as! LinkMomentCell).linkTitleLbl.font.pointSize)
//            if labelHeight > 32 {
//                (cell as! LinkMomentCell).linkTitleHeightContraints.constant = 32
//            }
//
//            (cell as! LinkMomentCell).linkIV.sd_setImage(with: URL(string: (moment.link?.icon)!), placeholderImage: UIImage(named: "placeholder.png"))
        
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: ImageMomentCell.cellReuseIdentifier(), for: indexPath) as! ImageMomentCell
            
            (cell as! ImageMomentCell).messageLbl.text = moment.body
            (cell as! ImageMomentCell).messageLbl.numberOfLines = 0
            (cell as! ImageMomentCell).messageLbl.sizeToFit()
            let labelHeight = (cell as! ImageMomentCell).messageLbl.heightForLabel(text: moment.body, font: (cell as! ImageMomentCell).messageLbl.font, width: (cell as! ImageMomentCell).messageLbl.font.pointSize)
            if labelHeight > 80 {
                (cell as! ImageMomentCell).messageLblHeightConstraints.constant = 80
            }
        
            let containerWidth: CGFloat = (cell as! ImageMomentCell).imageContainer.frame.width
            if moment.photoArray.count == 1 {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: containerWidth))
                imageView.sd_setImage(with: URL(string: (moment.photoArray.first?.small)!), placeholderImage: UIImage(named: "placeholder.png"))
                (cell as! ImageMomentCell).imageContainer.addSubview(imageView)
            }else if moment.photoArray.count == 2 {
                let twoImageView = TwoImageView(frame: (cell as! ImageMomentCell).imageContainer.bounds)
                twoImageView.image1Iv.sd_setImage(with: URL(string: moment.photoArray[0].origin), placeholderImage: UIImage(named: "placeholder.png"))
                twoImageView.image2Iv.sd_setImage(with: URL(string: moment.photoArray[1].origin), placeholderImage: UIImage(named: "placeholder.png"))
                (cell as! ImageMomentCell).imageContainer.addSubview(twoImageView)
            }else if moment.photoArray.count == 3 {
                let threeImageView = ThreeImageView(frame: (cell as! ImageMomentCell).imageContainer.bounds)
                threeImageView.image1Iv.sd_setImage(with: URL(string: moment.photoArray[0].origin), placeholderImage: UIImage(named: "placeholder.png"))
                threeImageView.image2Iv.sd_setImage(with: URL(string: moment.photoArray[1].origin), placeholderImage: UIImage(named: "placeholder.png"))
                threeImageView.image3Iv.sd_setImage(with: URL(string: moment.photoArray[1].origin), placeholderImage: UIImage(named: "placeholder.png"))
                (cell as! ImageMomentCell).imageContainer.addSubview(threeImageView)
            }else if moment.photoArray.count > 3{
                let forthImageView = ForthImageView(frame: (cell as! ImageMomentCell).imageContainer.bounds)
                forthImageView.image1Iv.sd_setImage(with: URL(string: moment.photoArray[0].origin), placeholderImage: UIImage(named: "placeholder.png"))
                forthImageView.image2Iv.sd_setImage(with: URL(string: moment.photoArray[1].origin), placeholderImage: UIImage(named: "placeholder.png"))
                forthImageView.image3Iv.sd_setImage(with: URL(string: moment.photoArray[2].origin), placeholderImage: UIImage(named: "placeholder.png"))
                forthImageView.image4Iv.sd_setImage(with: URL(string: moment.photoArray[3].origin), placeholderImage: UIImage(named: "placeholder.png"))
                (cell as! ImageMomentCell).imageContainer.addSubview(forthImageView)
            }else{
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: containerWidth))
                imageView.image = UIImage(named: "placeholder.png")
                (cell as! ImageMomentCell).imageContainer.addSubview(imageView)
            }
            
        }
        
        return cell
    }
    
}





































