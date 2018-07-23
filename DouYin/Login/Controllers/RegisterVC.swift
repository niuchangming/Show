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
    func registerCompleted(response: NSDictionary)
    func registerFailed(error: Error)
}

class RegisterVC: UIViewController {
    
    @IBOutlet weak var mobileNoTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    @IBOutlet weak var popupContainer: UIView! {
        didSet {
            popupContainer.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        }
    }
    weak var delegate: RegisterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        ConnectionManager.shareManager.request(method: .post, url: String(format: "%@signup", Constants.HOST), parames: ["phone": mobile!, "password": password!, "countryCode": "65"], succeed: { [unowned self] (responseJson) in
                self.loadingBar.stopAnimating()
                self.dismiss(animated: true, completion: {
                    self.delegate?.registerCompleted(response: responseJson as! NSDictionary)
                })
            }, failure: { (error) in
                self.loadingBar.stopAnimating()
                self.dismiss(animated: true, completion: {
                    self.delegate?.registerFailed(error: error!)
                })
            })
        
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
