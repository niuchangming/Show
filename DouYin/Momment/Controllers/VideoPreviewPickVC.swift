//
//  VideoPreviewPickVC.swift
//  DouYin
//
//  Created by Niu Changming on 16/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class VideoPreviewPickVC: UIViewController {

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var coverIv: UIImageView!
    @IBOutlet weak var videoView: VideoView!
    
    var fileUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.videoView.configure(url: (fileUrl?.absoluteString)!)
        self.videoView.isLoop = true
        self.videoView.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func closeBtnClicked(_ sender: Any) {
        
    }

}
