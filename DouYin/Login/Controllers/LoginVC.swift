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
import MIBlurPopup

class LoginVC: UIViewController{

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
    @IBOutlet weak var dismissBtn: UIButton!
    
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
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
        self.view.bringSubview(toFront: dismissBtn)
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
        let mobile = self.mobileNoTF.text as NSString?
        let password = self.passwordTF.text as NSString?
        if(!Utils.isNotNil(obj: mobile)){
            self.mobileNoTF.placeholder = "输入您的手机号码";
            self.mobileNoTF.setValue(UIColor(hexString: Constants.ColorScheme.redColor), forKeyPath: "_placeholderLabel.textColor")
            return
        }

        if(!Utils.isNumber(str: mobile! as String)){
            self.mobileNoTF.placeholder = "您的手机号码格式不正确";
            self.mobileNoTF.setValue(UIColor(hexString: Constants.ColorScheme.redColor), forKeyPath: "_placeholderLabel.textColor")
            return
        }

        if(!Utils.isNotNil(obj: password!)){
            self.passwordTF.placeholder = "输入您的登陆密码";
            self.passwordTF.setValue(UIColor(hexString: Constants.ColorScheme.redColor), forKeyPath: "_placeholderLabel.textColor")
            return
        }

        self.loadingBar.startAnimating()
        Account().mobileLogin(countryCode: "65", mobile: mobile! as String, password: password! as String) { (account, message) in

            if account != nil {
                AuthUtils.share.saveLoginInfo(account: account!)
                self.dismiss(animated: true)
            }else{
                let alert = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

            self.loadingBar.stopAnimating()
        }
    }
    
    func verify2FA(account: Account){
        let popupVC = Verify2faVC()
        popupVC.apiToken = account.token
        popupVC.countryCode = account.countryCode
        popupVC.mobile = account.mobile
        popupVC.delegate = self
        MIBlurPopup.show(popupVC, on: self)
    }
    
    @IBAction func registerBtnClicked(_ sender: Any) {
        let popupVC = RegisterVC()
        popupVC.delegate = self
        MIBlurPopup.show(popupVC, on: self)
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
//                AuthUtils.shareManager.saveWechatInfo(result: wxAuth)
                self.dismiss(animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
                let actionKnown = UIAlertAction(title: "知道了", style: .cancel) { (action:UIAlertAction) in}
                alertController.addAction(actionKnown)
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
                self.facebookLogin(fbResult: loginResult!)
            }
        }
    }
    
    func facebookLogin(fbResult: FBSDKLoginManagerLoginResult){
        self.loadingBar.startAnimating()

        Account().facebookLogin(fbResult: fbResult) { (account, message) in
            if account != nil {
                AuthUtils.share.saveFacebookInfo(result: fbResult, account: account!)
                self.dismiss(animated: true)
            }else{
                let alert = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            self.loadingBar.stopAnimating()
        }
        
    }
    
    @IBAction func dismissBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

extension LoginVC: RegisterDelegate, Verify2faDelegate {
    
    func registerCompleted(account: Account) {
        self.verify2FA(account: account)
    }
    
    func registerFailed(message: String) {
        let alertController = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
        let actionKnown = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction) in}
        alertController.addAction(actionKnown)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func verifyCompleted(account: Account) {
        AuthUtils.share.saveLoginInfo(account: account)
        self.dismiss(animated: true)
    }
    
    func verifyFailed(message: String) {
        let alertController = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
        let actionKnown = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction) in}
        alertController.addAction(actionKnown)
        self.present(alertController, animated: true, completion: nil)
    }
}
