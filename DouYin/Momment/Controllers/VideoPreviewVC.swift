//
//  VideoPreviewVC.swift
//  DouYin
//
//  Created by Niu Changming on 17/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class VideoPreviewVC: UITableViewController {
    var previewImage: UIImage!
    @IBOutlet weak var atFriendBtn: UIButton!{
        didSet{
            atFriendBtn.clipsToBounds = true
            atFriendBtn.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        }
    }
    @IBOutlet weak var messageTv: UITextView!
    @IBOutlet weak var previewIv: UIImageView!{
        didSet{
            previewIv.clipsToBounds = true
            previewIv.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViews()
    }
    
    func loadViews(){
        previewIv.image = previewImage
        
        tableView.tableFooterView = UIView()
    }

    @IBAction func closeBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func atFirendsBtnClicked(_ sender: Any) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension VideoPreviewVC: 













