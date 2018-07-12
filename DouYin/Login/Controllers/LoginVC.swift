//
//  LoginVC.swift
//  DouYin
//
//  Created by Niu Changming on 10/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import FBSDKLoginKit
import FBSDKCoreKit

class LoginVC: UIViewController {

    @IBOutlet weak var loginBgIV: UIImageView!
    
    @IBOutlet weak var fieldBgView: UIView!
    @IBOutlet weak var mobileNoBgView: UIView!
    @IBOutlet weak var mobileNoTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtnBgView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtnBgView: UIView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var forgetPwdBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var wechatBtn: UIButton!
    
    var blurredEffectView: UIView?
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initVideo()
    }
    
    func initUI(){
        let blurImage: UIImage = UIImage(named: "login_bg")!
        let _ = blurImage.gaussianBlur(blurAmount: 0.6)
        loginBgIV.image = blurImage
        
        blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurredEffectView?.alpha = 0.6
        blurredEffectView?.layer.zPosition = -1
        view.addSubview(blurredEffectView!)
        
        mobileNoBgView.clipsToBounds = true
        mobileNoBgView.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        passwordTF.clipsToBounds = true
        passwordTF.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        loginBtnBgView.clipsToBounds = true
        loginBtnBgView.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        registerBtnBgView.clipsToBounds = true
        registerBtnBgView.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        
        self.view.bringSubview(toFront: fieldBgView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -2
        playerLayer.frame = self.view.bounds
        view.layer.addSublayer(playerLayer)
        
        blurredEffectView?.frame = loginBgIV.bounds
    }
    
    func initVideo() {
        player = AVPlayer(url: Bundle.main.url(forResource: "login_vd", withExtension: "mov")!)
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        player?.play()
    
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.loopVideo),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func loopVideo() {
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
    
    @IBAction func forgetPwdBtnClicked(_ sender: Any) {
    
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func registerBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func wechatBtnClicked(_ sender: Any) {
        NotificationCenter.default.addObserver(self, selector: #selector(wechatAuthSuccess(notification:)), name: .wechatAuthSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(wechatAuthFail(notification:)), name: .wechatAuthSuccess, object: nil)
        
        let req: SendAuthReq = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "show_wechat_auth";
        WXApi.send(req)
    }
    
    @objc func wechatAuthSuccess(notification: NSNotification)  {
        let code = notification.userInfo!["code"] as! String        
        let wxAuth: WXAuth = WXAuth(code: code)
        wxAuth.getData { (message) in
            if message == "Success" {
                AuthUtils.shareManager.saveWechatInfo(result: wxAuth)
                self.dismiss(animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func wechatAuthFail(notification: NSNotification)  {
        
    }
    
    @IBAction func facebookBtnClicked(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        
        loginManager.logIn(withReadPermissions: [ "public_profile", "email" ], from: self) { (loginResult, error) in
            if error != nil {
                let alertController = UIAlertController(title: "Login Failed", message: error.debugDescription, preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                return;
            }
            
            if loginResult?.isCancelled == false {
                AuthUtils.shareManager.saveFacebookInfo(result: loginResult!)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension Notification.Name {
    static let wechatAuthSuccess = Notification.Name("wechat_auth_success")
    static let wechatAuthFailed = Notification.Name("wechat_auth_failed")
}
