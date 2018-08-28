//
//  MyMomentVC.swift
//  DouYin
//
//  Created by Niu Changming on 2/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class MyMomentVC: UIViewController {
    
    var moments: [Moment] = []
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
    }
}

extension MyMomentVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        let moment = self.moments[indexPath.row]
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
            let labelHeight = (cell as! ImageMomentCell).messageLbl.heightForLabel(text: moment.body, font: (cell as! ImageMomentCell).messageLbl.font, width: (cell as! ImageMomentCell).messageLbl.font.pointSize)
            if labelHeight > 80 {
                (cell as! ImageMomentCell).messageLblHeightConstraints.constant = 80
            }
        
            let containerWidth: CGFloat = (cell as! ImageMomentCell).imageContainer.frame.width
            if moment.photoArray?.count == 1 {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: containerWidth))
                imageView.sd_setImage(with: URL(string: (moment.photoArray?.first?.small)!), placeholderImage: UIImage(named: "placeholder.png"))
                (cell as! ImageMomentCell).imageContainer.addSubview(imageView)
            }else if moment.photoArray?.count == 2 {
                for i in 0..<2 {
                    let imageWidth: CGFloat = containerWidth / 2
                    
                    let imageView = UIImageView(frame: CGRect(x: CGFloat(i)*imageWidth, y: 0, width: imageWidth, height: (cell as! ImageMomentCell).imageContainer.frame.height))
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    imageView.sd_setImage(with: URL(string: moment.photoArray![i].small), placeholderImage: UIImage(named: "placeholder.png"))
                    (cell as! ImageMomentCell).imageContainer.addSubview(imageView)
                }
            }else{
                for i in 0..<4 {
                    let imageWidth: CGFloat = (cell as! ImageMomentCell).imageContainer.frame.size.width / 2
                    let imageHeight: CGFloat = imageWidth
                    var imageX: CGFloat = 0
                    var imageY: CGFloat = 0
                    if(i == 1 || i == 3){
                        imageX = imageWidth
                    }
                    if(i > 1){
                        imageY = imageHeight
                    }
                    
                    let imageView = UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight))
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    imageView.sd_setImage(with: URL(string: moment.photoArray![i].small), placeholderImage: UIImage(named: "placeholder.png"))
                    (cell as! ImageMomentCell).imageContainer.addSubview(imageView)
                }
            }
            
        }
        
        return cell
    }
    
}





































