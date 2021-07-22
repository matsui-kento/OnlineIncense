//
//  BankAccount.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/19.
//

import Foundation

struct BankAccount {
    let name: String
    let bankAccountName: String
    let bankNumber: String
    let bankName: String
    let branchCode: String
    let kindBankAccount: String
    let type: String
    let bankAccountNumber: String
    let uid: String
    let documentID: String
    
    init(dic: [String:Any]) {
        self.name = dic["name"] as? String ?? ""
        self.bankAccountName = dic["bankAccountName"] as? String ?? ""
        self.bankNumber = dic["bankNumber"] as? String ?? ""
        self.bankName = dic["bankName"] as? String ?? ""
        self.branchCode = dic["branchCode"] as? String ?? ""
        self.kindBankAccount = dic["kindBankAccount"] as? String ?? ""
        self.type = dic["type"] as? String ?? ""
        self.bankAccountNumber = dic["bankAccountNumber"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.documentID = dic["documentID"] as? String ?? ""
    }
}
