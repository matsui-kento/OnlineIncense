//
//  secret.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/22.
//

import Foundation
import OmiseSDK

class Omise {
    private init() {}
    static let shared = Omise()

    let publicKey = "pkey_test_5oi3wew1ac5xrchxet8"
    let secretKey = "skey_test_5ogwkc4d99dvxi9z15q"
    let client = OmiseSDK.Client.init(publicKey: "pkey_test_5oi3wew1ac5xrchxet8")
}
