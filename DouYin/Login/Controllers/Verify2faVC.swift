//
//  Verify2faVC.swift
//  DouYin
//
//  Created by Niu Changming on 23/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import MIBlurPopup

protocol Verify2faDelegate: class {
    func verifyCompleted(account: Account)
    func verifyFailed(message: String)
}

class Verify2faVC: UIViewController {
    var countryCode: String? = ""
    var mobile: String? = ""
    var apiToken: String? = ""
    
    @IBOutlet weak var codeTf: UITextField!
    @IBOutlet weak var verifyBtn: UIButton!{
        didSet{
            verifyBtn.clipsToBounds = true
            verifyBtn.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        }
    }
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    @IBOutlet weak var cancelBtn: UIButton!{
        didSet{
            self.cancelBtn.clipsToBounds = true
            self.cancelBtn.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        }
    }
    weak var delegate: Verify2faDelegate?
    @IBOutlet weak var popupContainer: UIView! {
        didSet {
            popupContainer.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        }
    }
    var seconds = 60
    var timer = Timer()
    var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationCapturesStatusBarAppearance = true
        runTimer()
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func verifyBtnClicked(_ sender: UIButton) {
    
        if sender.title(for: .normal)?.range(of:"Verify") != nil {
            let code = self.codeTf.text as NSString?
            if(!Utils.isNotNil(obj: code) || self.codeTf.text?.count != 4 || !Utils.isNumber(str: code! as String)){
                self.codeTf.placeholder = "输入4位验证码";
                self.codeTf.setValue(UIColor(hexString: Constants.ColorScheme.redColor), forKeyPath: "_placeholderLabel.textColor")
                return
            }
            
            self.loadingBar.startAnimating()
            
            Account().verify2FACode(apiToken: apiToken!, verifyCode: code! as String) { (account, message) in
                self.dismiss(animated: true, completion: {
                    
                    if account != nil{
                        self.delegate?.verifyCompleted(account: account!)
                    }else{
                        self.delegate?.verifyFailed(message: message)
                    }
                    
                })
                
                self.loadingBar.stopAnimating()
            }
        }else{
            if isTimerRunning == false {
                //Resend API
                runTimer()
                verifyBtn.setTitle(String(format: "Verify(%i)", seconds), for: .normal)
            }
        }
    }
    
    func runTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(Verify2faVC.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        verifyBtn.setTitle(String(format: "Verify(%i)", seconds), for: .normal)
        if(seconds == 0){
            timer.invalidate()
            isTimerRunning = false
            seconds = 60
            verifyBtn.setTitle("Re-Send", for: .normal)
        }else{
            seconds -= 1
        }
    }
    
}

extension Verify2faVC: MIBlurPopupDelegate {
    
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






