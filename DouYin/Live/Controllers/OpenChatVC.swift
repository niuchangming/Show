//
//  OpenChatVC.swift
//  DouYin
//
//  Created by Niu Changming on 19/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import MIBlurPopup

class OpenChatVC: UIViewController, RegisterDelegate, Verify2faDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showBtnClicked(_ sender: UIButton) {
        let popupVC = RegisterVC()
        popupVC.delegate = self
        MIBlurPopup.show(popupVC, on: self)
    }
    
    func registerCompleted(response: NSDictionary) {
        let errCode = response["errorCode"] as! Int
        
        guard errCode == 1 else{
            let message = response["message"] as! String
            let alertController = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
            let actionKnown = UIAlertAction(title: "知道了", style: .cancel) { (action:UIAlertAction) in}
            alertController.addAction(actionKnown)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let token = response["token"] as! String
        self.verify(token: token)
    }
    
    func registerFailed(error: Error) {
        let alertController = UIAlertController(title: "Failed", message: error.localizedDescription, preferredStyle: .alert)
        let actionKnown = UIAlertAction(title: "知道了", style: .cancel) { (action:UIAlertAction) in}
        alertController.addAction(actionKnown)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func verify(token: String)  {
        let popupVC = Verify2faVC()
        popupVC.delegate = self
        MIBlurPopup.show(popupVC, on: self)
    }
    
    func verifyCompleted(response: NSDictionary) {
        let errCode = response["errorCode"] as! Int
        
        guard errCode == 1 else{
            let message = response["message"] as! String
            let alertController = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
            let actionKnown = UIAlertAction(title: "知道了", style: .cancel) { (action:UIAlertAction) in}
            alertController.addAction(actionKnown)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let token = response["token"] as! String
        print("----------> \(token)")
        
//        AuthUtils.shareManager.saveLoginInfo(countryCode: <#T##String#>, mobile: <#T##String#>, accessToken: <#T##String#>)
    }
    
    func verifyFailed(error: Error) {
        let alertController = UIAlertController(title: "Failed", message: error.localizedDescription, preferredStyle: .alert)
        let actionKnown = UIAlertAction(title: "知道了", style: .cancel) { (action:UIAlertAction) in}
        alertController.addAction(actionKnown)
        self.present(alertController, animated: true, completion: nil)
    }

}












