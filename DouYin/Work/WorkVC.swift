//
//  ViewController.swift
//  DouYin
//
//  Created by Niu Changming on 12/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import SDWebImage

class WorkVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var works: [Work] = [Work]();
    
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
        
        initDimData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return works.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkCollectionCell", for: indexPath) as! WorkCollectionCell
        
        let work: Work = works[indexPath.row]
        
        cell.usernameLbl.text = work.name
        cell.workIV.sd_setImage(with: URL(string: work.coverImage), placeholderImage: UIImage(named: "placeholder.png"))
        cell.distanceLbl.text = "> 3Km"
        cell.userPhotoIV.sd_setImage(with: URL(string: work.avatarImage), placeholderImage: UIImage(named: "placeholder.png"))
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let workDetailVC = WorkDetailVC()
        workDetailVC.works = works
        self.present(workDetailVC, animated: true, completion: nil)
    }
    
    func initDimData() {
        let work1 = Work(name: "ZhangSan", coverImage: "http://p3.pstatp.com/large/3dad000a4ea0656e721d.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg", latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=bea0903abb954f58ac0e17c21226a3c3&line=0&app_id=1115&watermark=1")
        
        let work2 = Work(name: "ZhangSan", coverImage: "http://p1.pstatp.com/large/3d95000a215e1ea9848d.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=e3da4d9917364f2b8f5826487563d763&line=0&app_id=1115&watermark=1")
        
        let work3 = Work(name: "ZhangSan", coverImage: "http://p1.pstatp.com/medium/3ade000cbe377c23e37c.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=e486dc4931d041c1b5405e9fcb35e0ac&line=0&app_id=1115&quality=720p")
        
        let work4 = Work(name: "ZhangSan", coverImage: "http://p1.pstatp.com/medium/3aa9000f4ffbc2049d36.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=f56df03dea804541a9fcd4d1cc26eefd&line=0&app_id=1115&quality=720p")
        
        let work5 = Work(name: "ZhangSan", coverImage: "http://p3.pstatp.com/medium/397a0008958c6b5df341.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=15105c5f27db4c789b8ba43c3e5056c4&line=1&app_id=1115&quality=720p")
        
        let work6 = Work(name: "ZhangSan", coverImage: "http://p3.pstatp.com/large/3ce20012297d43ee5a51.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=dcb9b966feaf44b9bbb182ed6ec18905&line=0&app_id=1115&watermark=1")
        
        let work7 = Work(name: "ZhangSan", coverImage: "http://p3.pstatp.com/large/39950011b1889ebc14b3.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=b05b22407e0c4ecfa9b9d9d61b3cde8d&line=0&app_id=1115&watermark=1")
        
        let work8 = Work(name: "ZhangSan", coverImage: "http://p3.pstatp.com/large/3daf0001af256c3558b5.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=3addc2c120c64055b4d8d5aa02ed0358&line=0&app_id=1115&watermark=1")
        
        let work9 = Work(name: "ZhangSan", coverImage: "http://p3.pstatp.com/large/3b7c000237cc7121d0fe.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=0023998b5c434594a341aa14ca246e78&line=0&app_id=1115&watermark=1")
        
        let work10 = Work(name: "ZhangSan", coverImage: "http://p1.pstatp.com/large/3ad40009935d10c54b26.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=89a4c97611cb4e968ee527064910f8f5&line=0&app_id=1115&watermark=1")
        
        let work11 = Work(name: "ZhangSan", coverImage: "http://p1.pstatp.com/large/3c19000ddcce5d2b9c45.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=a3480c04fb474d8abe67b92ba3092385&line=0&app_id=1115&watermark=1")
        
        let work12 = Work(name: "ZhangSan", coverImage: "http://p3.pstatp.com/large/3dc7000d28124e3243d9.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=a32e93a6db1946b1923dab80426cf408&line=0&app_id=1115&watermark=1")
        
        let work13 = Work(name: "ZhangSan", coverImage: "http://p9.pstatp.com/large/3dae0003c1dde8e03f33.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=4066031765e64444aec56555c7916c88&line=0&app_id=1115&watermark=1")
        
        let work14 = Work(name: "ZhangSan", coverImage: "http://p1.pstatp.com/large/3d6a000cf2dbe54346ee.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=de5fb0f7a58c474f99b0e36f14ab4f5e&line=0&app_id=1115&watermark=1")
        
        let work15 = Work(name: "ZhangSan", coverImage: "http://p9.pstatp.com/large/3b760000ed3d54f9ed3f.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=f74e414de26c4c3ab496e145e2133e4e&line=0&app_id=1115&watermark=1")
        
        let work16 = Work(name: "ZhangSan", coverImage: "http://p9.pstatp.com/large/3acd0006688592449b71.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=e46a3badde1c4c45bdbd955f8cc3d4a0&line=0&app_id=1115&watermark=1")
        
        let work17 = Work(name: "ZhangSan", coverImage: "http://p1.pstatp.com/large/3bbf000c4098f574ce98.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=05cea72731f048dbb88e330a36ec5d7b&line=0&app_id=1115&watermark=1")
        
        let work18 = Work(name: "ZhangSan", coverImage: "http://p3.pstatp.com/large/3d9d0003948f633347ef.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=287a0f388ff94132a0378590ce2ea10a&line=0&app_id=1115&watermark=1")
        
        let work19 = Work(name: "ZhangSan", coverImage: "http://p1.pstatp.com/large/3a3100095c93f8ad10fd.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=ca29113defee42629100e25bae76f0cb&line=0&app_id=1115&watermark=1")
        
        let work20 = Work(name: "ZhangSan", coverImage: "http://p3.pstatp.com/large/3d7c00020fd03f87fe46.jpg", avatarImage: "https://pic4.zhimg.com/50/v2-f9dccd837594460045e0b3960395a6e1_hd.jpg",latitude: 0, longitude: 0, workLink: "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=f8f3e8f939c74180ac58a07ae1c3db67&line=0&app_id=1115&watermark=1")
    
        works.append(work1)
        works.append(work2)
        works.append(work3)
        works.append(work4)
        works.append(work5)
        works.append(work6)
        works.append(work7)
        works.append(work8)
        works.append(work9)
        works.append(work10)
        works.append(work11)
        works.append(work12)
        works.append(work13)
        works.append(work14)
        works.append(work15)
        works.append(work16)
        works.append(work17)
        works.append(work18)
        works.append(work19)
        works.append(work20)
    }
}

