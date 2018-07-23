//
//  Gift.swift
//  DouYin
//
//  Created by Niu Changming on 14/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import HandyJSON

class GiftData: HandyJSON {
    var data = [Gift]()
    
    required init() {}
    
    func getData(message:@escaping (String) -> ()) {
        if let path = Bundle.main.path(forResource: "gift_data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let responseJson = jsonResult as? NSDictionary {
                    let model = GiftData.deserialize(from: responseJson)
                    self.data = (model?.data)!
                    
                    message("Success")
                }else{
                    message("Fail")
                }
            } catch {
                 message("Fail")
            }
        }else{
             message("Fail")
        }
    }
}


class Gift: HandyJSON{
    var id: String = ""
    var icon: String = ""
    var icon_gif: String = ""
    var name: String = ""
    var type: String = ""
    var value: String = ""
    var isSelected: Bool = false
    var username: String = ""
    var cost_type: Int = 0
    
    required init() {}
}

class GiftSend: HandyJSON{
    var id: String = ""
    var icon: String = ""
    var icon_gif: String = ""
    var name: String = ""
    var username: String = ""
    var defaultCount: Int = 0
    var sendCount: Int = 0
    
    required init() {}
}


