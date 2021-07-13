//
//  Info.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/11.
//

import Foundation
import UIKit

struct Info {
    let deceasedName: String
    let deceasedHiragana: String
    let homeless: String
    let prefecture: String
    let place: String
    let address: String
    let schedule: String
    let uid: String
    
    init(dic: [String:Any]) {
        self.deceasedName = dic["deceasedName"] as? String ?? ""
        self.deceasedHiragana = dic["deceasedHiragana"] as? String ?? ""
        self.homeless = dic["homeless"] as? String ?? ""
        self.prefecture = dic["prefecture"] as? String ?? ""
        self.place = dic["place"] as? String ?? ""
        self.address = dic["address"] as? String ?? ""
        self.schedule = dic["schedule"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
    }
}
