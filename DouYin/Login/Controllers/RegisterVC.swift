//
//  RegisterVC.swift
//  DouYin
//
//  Created by Niu Changming on 23/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import MIBlurPopup

protocol RegisterDelegate: class {
    func registerCompleted(account: Account)
    func registerFailed(message: String)
}

class RegisterVC: UIViewController {
    
    weak var delegate: RegisterDelegate?
    @IBOutlet weak var mobileNoTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    @IBOutlet weak var popupContainer: UIView! {
        didSet {
            popupContainer.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        }
    }
    @IBOutlet weak var signupBtn: UIButton! {
        didSet{
            signupBtn.clipsToBounds = true
            signupBtn.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        }
    }
    @IBOutlet weak var cancelBtn: UIButton! {
        didSet{
            cancelBtn.clipsToBounds = true
            cancelBtn.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationCapturesStatusBarAppearance = true
        view.frame = UIScreen.main.bounds
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signupBtnClicked(_ sender: UIButton) {
        let mobile = self.mobileNoTf.text as NSString?
        let password = self.passwordTf.text as NSString?
        if(!Utils.isNotNil(obj: mobile)){
            self.mobileNoTf.placeholder = "输入您的手机号码";
            self.mobileNoTf.setValue(UIColor(hexString: Constants.ColorScheme.redColor), forKeyPath: "_placeholderLabel.textColor")
            return
        }
        
        if(!Utils.isNumber(str: String(mobile!))){
            self.mobileNoTf.placeholder = "您的手机号码格式不正确";
            self.mobileNoTf.setValue(UIColor(hexString: Constants.ColorScheme.redColor), forKeyPath: "_placeholderLabel.textColor")
            return
        }
        
        if(!Utils.isNotNil(obj: password)){
            self.passwordTf.placeholder = "输入您的登陆密码";
            self.passwordTf.setValue(UIColor(hexString: Constants.ColorScheme.redColor), forKeyPath: "_placeholderLabel.textColor")
            return
        }
        
        self.loadingBar.startAnimating()
        Account().mobileSignup(countryCode: "65", mobile: mobile! as String, password: password! as String) { (account, message) in
            if(account != nil){
                self.dismiss(animated: true, completion: {
                    self.delegate?.registerCompleted(account: account!)
                })
                self.loadingBar.stopAnimating()
            }else{
                self.dismiss(animated: true, completion: {
                    self.delegate?.registerFailed(message: message)
                })
                self.loadingBar.stopAnimating()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension RegisterVC: MIBlurPopupDelegate {
    
    var popupView: UIView {
        return self.popupContainer
    }
    
    var blurEffectStyle: UIBlurEffectStyle {
        return .light
    }
    
    var initialScaleAmmount: CGFloat {
        return 0.7
    }
    
    var animationDuration: TimeInterval {
        return TimeInterval(0.3)
    }
    
}
