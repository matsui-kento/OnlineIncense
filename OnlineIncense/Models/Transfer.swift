//
//  Transfer.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/22.
//

import Foundation

struct Transfer {
    let incensePrice: String
    let transferPrice: String
    let bankAccountName: String
    let bankName: String
    let branchCode: String
    let bankAccountNumber: String
    let uid: String
    let documentID: String
    
    init(dic: [String:Any]) {
        self.incensePrice = dic["incensePrice"] as? String ?? ""
        self.transferPrice = dic["transferPrice"] as? String ?? ""
        self.bankAccountName = dic["bankAccountName"] as? String ?? ""
        self.bankName = dic["bankName"] as? String ?? ""
        self.branchCode = dic["branchCode"] as? String ?? ""
        self.bankAccountNumber = dic["bankAccountNumber"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.documentID = dic["documentID"] as? String ?? ""
    }
}

