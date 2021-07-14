//
//  Participant.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/14.
//

import Foundation

struct Participant {
    
    let name: String
    let address: String
    let number: String
    let company: String
    let relation: String
    
    init(dic: [String:Any]) {
        self.name = dic["name"] as? String ?? ""
        self.address = dic["address"] as? String ?? ""
        self.number = dic["number"] as? String ?? ""
        self.company = dic["company"] as? String ?? ""
        self.relation = dic["relation"] as? String ?? ""
    }
}