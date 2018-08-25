//
//  PersonData.swift
//  DouYin
//
//  Created by Niu Changming on 25/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import HandyJSON

class PersonData: HandyJSON {
    var data: Person?
    
    required init() {}
    
    func getData(completed :@escaping (Status) -> ()) {
        ConnectionManager.shareManager.request(method: .post, url: String(format: "%@user/getUserprofile", Constants.HOST), parames: ["token": AuthUtils.share.apiToken() as AnyObject], succeed: { (responseJson) in
            
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            if errorCode == 1 {
                let model = PersonData.deserialize(from: responseJson as? NSDictionary)
                self.data = model?.data
    
                completed(.success)
            }else{
                completed(.failure)
            }
        }) { (error) in
            completed(.failure)
        }
    }
    
    func saveName(name: String, isNickname: Bool, completed :@escaping (Status, String) -> ()) {
        
        var params: [String: AnyObject]!
        if(isNickname){
            params = ["nickName": name as AnyObject, "token": AuthUtils.share.apiToken() as AnyObject]
        }else{
            params = ["name": name as AnyObject, "token": AuthUtils.share.apiToken() as AnyObject]
        }
        ConnectionManager.shareManager.request(method: .post, url: String(format: "%@user/updateUserprofile", Constants.HOST), parames: params, succeed: { (responseJson) in
            
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            let message = response["message"] as! String
            if errorCode == 1 {
                completed(.success, message)
            }else{
                completed(.failure, message)
            }
        }) { (error) in
            completed(.failure, (error?.localizedDescription)!)
        }
    }
    
    func saveGender(isMale: Bool, completed :@escaping (Status, String) -> ()) {
        
        let params = ["gender": isMale ? 0 : 1, "token": AuthUtils.share.apiToken() as AnyObject] as [String : Any]
        ConnectionManager.shareManager.request(method: .post, url: String(format: "%@user/updateUserprofile", Constants.HOST), parames: params as [String : AnyObject], succeed: { (responseJson) in
            
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            let message = response["message"] as! String
            if errorCode == 1 {
                completed(.success, message)
            }else{
                completed(.failure, message)
            }
        }) { (error) in
            completed(.failure, (error?.localizedDescription)!)
        }
    }
    
    func saveBirthday(birthday: Date, completed :@escaping (Status, String) -> ()) {
        
        let params = ["birthday": birthday.toMillis() as AnyObject, "token": AuthUtils.share.apiToken() as AnyObject]
        ConnectionManager.shareManager.request(method: .post, url: String(format: "%@user/updateUserprofile", Constants.HOST), parames: params, succeed: { (responseJson) in
            
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            let message = response["message"] as! String
            if errorCode == 1 {
                completed(.success, message)
            }else{
                completed(.failure, message)
            }
        }) { (error) in
            completed(.failure, (error?.localizedDescription)!)
        }
    }
    
    func saveWhatup(whatup: String, completed :@escaping (Status, String) -> ()) {
        
        let params = ["whatup": whatup as AnyObject, "token": AuthUtils.share.apiToken() as AnyObject]
        ConnectionManager.shareManager.request(method: .post, url: String(format: "%@user/updateUserprofile", Constants.HOST), parames: params, succeed: { (responseJson) in
            
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            let message = response["message"] as! String
            if errorCode == 1 {
                completed(.success, message)
            }else{
                completed(.failure, message)
            }
        }) { (error) in
            completed(.failure, (error?.localizedDescription)!)
        }
    }
    
    func saveRegion(country: Country, completed :@escaping (Status, String) -> ()) {
        let params = ["region": country.code as AnyObject, "token": AuthUtils.share.apiToken() as AnyObject]
        ConnectionManager.shareManager.request(method: .post, url: String(format: "%@user/updateUserprofile", Constants.HOST), parames: params, succeed: { (responseJson) in
            
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            let message = response["message"] as! String
            if errorCode == 1 {
                completed(.success, message)
            }else{
                completed(.failure, message)
            }
        }) { (error) in
            completed(.failure, (error?.localizedDescription)!)
        }
    }
    
    func uploadImage(isCover: Bool, image: UIImage, completed :@escaping(Status, String, Bool) -> ()) {
        let params = ["token": AuthUtils.share.apiToken() as AnyObject]
        
        var multiParts: [String: AnyObject]!
        if isCover {
            multiParts = ["coverImage": UIImageJPEGRepresentation(image, 1)] as [String : AnyObject]
        }else {
            multiParts = ["avatar": UIImageJPEGRepresentation(image, 1)] as [String : AnyObject]
        }
        
        ConnectionManager.shareManager.uploadMultiparts(url: String(format: "%@broadcast/infoUpdate", Constants.HOST), params: params, multiparts: multiParts, succeed: { (responseJson) in
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            let message = response["message"] as! String
            if errorCode == 1 {
                completed(.success, message, isCover)
            }else{
                completed(.failure, message, isCover)
            }
        }) { (error) in
            completed(.failure, (error?.localizedDescription)!, isCover)
        }
    }
}

class Person: HandyJSON{
    var role: Int = 0
    var countryCode: String = ""
    var mobile: String = ""
    var name: String = ""
    var nickName: String = ""
    var userCode: String = ""
    var region: String = ""
    var gender: Int = 0
    var birthday: Int64 = 0
    var whatsup: String = ""
    var followerAmount: Int = 0
    var followingAmount: Int = 0
    var avatar: Photo?
    var coverImage: Photo?
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.role <-- "roleType"
        
        mapper <<<
            self.followerAmount <-- "followers"
        
        mapper <<<
            self.followingAmount <-- "following"
        
        mapper <<<
            self.avatar <-- "Avatar"
    }
}






























