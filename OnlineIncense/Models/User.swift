//
//  User.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/14.
//

import Foundation

struct User {
    let name: String
    let email: String
    let uid: String
    
    init(dic: [String:Any]) {
        self.name = dic["name"] as? String ?? ""
        self.email = dic["email"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
    }
}
