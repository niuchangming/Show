//
//  BroadcastVC.swift
//  DouYin
//
//  Created by Niu Changming on 5/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class BroadcastVC: UIViewController{
    
    @IBOutlet weak var startBtn: UIButton!

    lazy var bambuserView: BambuserView = {
        let bambuserView = BambuserView(preparePreset: kSessionPresetAuto)
        bambuserView?.applicationId = Constants.BAMBUSER_APP_ID
        return bambuserView!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bambuserView.orientation = UIApplication.shared.statusBarOrientation
        self.bambuserView.delegate = self
        self.view.addSubview(self.bambuserView.view)
        
        self.view.bringSubview(toFront: startBtn)
        
        bambuserView.startCapture()
    }
    
    override func viewWillLayoutSubviews() {
        var statusBarOffset : CGFloat = 0.0
        statusBarOffset = CGFloat(self.topLayoutGuide.length)
        self.bambuserView.previewFrame = CGRect(x: 0.0, y: 0.0 + statusBarOffset, width: self.view.bounds.size.width, height: self.view.bounds.size.height - statusBarOffset)
    }
    
    @IBAction func startBtnClicked(_ sender: Any) {
        startBtn.setTitle("Connecting", for: UIControlState.normal)
        startBtn.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        startBtn.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)
        bambuserView.startBroadcasting()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension BroadcastVC: BambuserViewDelegate{
    
    func broadcastStarted() {
        startBtn.setTitle("Stop", for: UIControlState.normal)
        startBtn.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        startBtn.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)
    }
    
    func broadcastStopped() {
        startBtn.setTitle("Broadcast", for: UIControlState.normal)
        startBtn.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        startBtn.addTarget(self, action: #selector(BroadcastVC.startBtnClicked(_:)), for: UIControlEvents.touchUpInside)
    }
}
