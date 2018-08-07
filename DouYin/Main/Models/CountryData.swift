//
//  Country.swift
//  DouYin
//
//  Created by Niu Changming on 31/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import HandyJSON

class CountryData: HandyJSON {
    var data = [Country]()
    
    required init() {}

    func getData(completed:@escaping (Bool) -> ()) {
        var isSuccess: Bool = false
        if let path = Bundle.main.path(forResource: "country_data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                if let responseJson = jsonResult as? NSDictionary {
                    let model = CountryData.deserialize(from: responseJson)
                    self.data = (model?.data)!
                    isSuccess = true
                }
            } catch let error{
                print("Json parser error: \(error)")
            }
        }else{
            print("Json parser error: File not exist.")
        }
        completed(isSuccess)
    }
}

class Country: HandyJSON {
    var name : String = ""
    var dialCode: String = ""
    var code: String = ""
    
    required init(){}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.dialCode <-- "dial_code"
    }
}


