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
        dimData()
    }
    
    func dimData(){
        let comment1 = Comment()
        comment1.author = "王二麻"
        comment1.content = "这是什么东西呀，我怎么没看过！"
        
        let comment2 = Comment()
        comment2.author = "王二麻"
        comment2.content = "我昨天逛街看到你和你两位的老公了！"
        
        let comment3 = Comment()
        comment3.author = "妈妈"
        comment3.content = "今晚回家吃饭哈😄"
        
//        let moment1 = MomentData()
//        moment1.author = "ZhangSan"
//        moment1.avatarLink = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDzLOpZHeOceHTTDjkzrhpTQnpA28LijJ_zjH7rb_z8Mk11jmX"
//        moment1.body = "因为对这两国来说有一场更加重要的比赛，就在那一瞬间，开哨了！12点钟的时候美方开了球，或者说打响了贸易战，当然也可以叫贸易摩擦的“第一枪”，一分钟之后，来而不往非礼也，中国不止是防守也开始了传控和相关的进攻，也开始反制。"
//        moment1.type = 0;
//        moment1.time = 1530978285049
//        moment1.comments = [comment1, comment2]
//        self.moments.append(moment1)
//
//        let moment2 = MomentData()
//        moment2.author = "小明"
//        moment2.avatarLink = "http://www.shuaigetuku.com/uploadfile/2017/0425/20170425013954916.jpg"
//        moment2.body = "一组真实没有PS的可爱型小帅哥照片分享给大家，暖暖的很招人喜欢。"
//        moment2.type = 1;
//        moment2.time = 1530978295049
//
//        let link2 = Link()
//        link2.link = "http://www.shuaigetuku.com/show-10-66-1.html"
//        link2.icon = "http://p1.ifengimg.com/a/2018/0420/c49f8f0f43579ebsize4_w50_h58.jpg"
//        link2.title = "一组真实没有PS的可爱型小帅哥照片分享给大家，暖暖的很招人喜欢。"
//        moment2.link = link2
//        moment2.comments = [comment1]
//        self.moments.append(moment2)
//
//        let moment3 = MomentData()
//        moment3.author = "小明"
//        moment3.avatarLink = "http://www.shuaigetuku.com/uploadfile/2017/0425/20170425013954916.jpg"
//        moment3.body = "一组真实没有PS的可爱型小帅哥照片分享给大家，暖暖的很招人喜欢。"
//        moment3.type = 2;
//        moment3.time = 1530978295049
//        moment3.pictures = ["https://pic.pimg.tw/nixojov/1466125488-1841874269_n.jpg?v=1466127109", "https://tw.bring-you.info/imgs/2015/04/%E9%AB%98%E9%9B%84%E7%BE%8E%E9%A3%9F%E5%A5%BD%E5%90%83%E6%AF%94%E8%96%A9-16.jpg", "https://d2j3coy501s4ze.cloudfront.net/images/11511/700/ff42ba91ff49e2309d4a35cc5c305c934b626d0e_57e8ca8b49d96.jpeg", "http://www.travel141.cn/wp-content/uploads/2017/05/shutterstock_323327855-768x512.jpg", "https://img.stillcarol.tw/20171001172350_98.jpg", "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Marina_Bay_Sands_in_the_evening_-_20101120.jpg/294px-Marina_Bay_Sands_in_the_evening_-_20101120.jpg", "https://content.shopback.com/tw/wp-content/uploads/2017/06/04222054/aotaro.jpg"]
//        moment3.comments = [comment1, comment2, comment3]
//        self.moments.append(moment3)
//
//        let moment4 = MomentData()
//        moment4.author = "小明"
//        moment4.avatarLink = "http://www.shuaigetuku.com/uploadfile/2017/0425/20170425013954916.jpg"
//        moment4.body = "一组真实没有PS的可爱型小帅哥照片分享给大家，暖暖的很招人喜欢。"
//        moment4.type = 2;
//        moment4.time = 1530978295049
//        moment4.pictures = ["https://pic.pimg.tw/nixojov/1466125488-1841874269_n.jpg?v=1466127109", "http://www.travel141.cn/wp-content/uploads/2017/05/shutterstock_323327855-768x512.jpg"]
//        moment4.comments = [comment1, comment2]
//        self.moments.append(moment4)
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
            if moment.images?.count == 1 {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: containerWidth))
                imageView.sd_setImage(with: URL(string: (moment.images?.first?.small)!), placeholderImage: UIImage(named: "placeholder.png"))
                (cell as! ImageMomentCell).imageContainer.addSubview(imageView)
            }else if moment.images?.count == 2 {
                for i in 0..<2 {
                    let imageWidth: CGFloat = containerWidth / 2
                    
                    let imageView = UIImageView(frame: CGRect(x: CGFloat(i)*imageWidth, y: 0, width: imageWidth, height: (cell as! ImageMomentCell).imageContainer.frame.height))
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    imageView.sd_setImage(with: URL(string: moment.images![i].small), placeholderImage: UIImage(named: "placeholder.png"))
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
                    imageView.sd_setImage(with: URL(string: moment.images![i].small), placeholderImage: UIImage(named: "placeholder.png"))
                    (cell as! ImageMomentCell).imageContainer.addSubview(imageView)
                }
            }
            
        }
        
        return cell
    }
    
}





































