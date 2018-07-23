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
    func verifyCompleted(response: NSDictionary)
    func verifyFailed(error: Error)
}

class Verify2faVC: UIViewController {

    @IBOutlet weak var codeTf: UITextField!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    weak var delegate: Verify2faDelegate?
    @IBOutlet weak var popupContainer: UIView! {
        didSet {
            popupContainer.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func verifyBtnClicked(_ sender: UIButton) {
        let code = self.codeTf.text as NSString?
        if(!Utils.isNotNil(obj: code) || self.codeTf.text?.count != 4 || !Utils.isNumber(str: code! as String)){
            self.codeTf.placeholder = "输入4位验证码";
            self.codeTf.setValue(UIColor(hexString: Constants.ColorScheme.redColor), forKeyPath: "_placeholderLabel.textColor")
            return
        }
        
        self.loadingBar.startAnimating()
        ConnectionManager.shareManager.request(method: .post, url: String(format: "%@2fa", Constants.HOST), parames: ["verifyCode":code!], succeed: { [unowned self] (responseJson) in
                self.loadingBar.stopAnimating()
                self.dismiss(animated: true, completion: {
                    self.delegate?.verifyCompleted(response: responseJson as! NSDictionary)
                })
            }, failure: { (error) in
                self.loadingBar.stopAnimating()
                self.dismiss(animated: true, completion: {
                    self.delegate?.verifyFailed(error: error!)
                })
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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






