//
//  Padding.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/08/01.
//

import Foundation
import UIKit

class Padding {
    private init() {}
    static let shared = Padding()

    let screenHeight = UIScreen.main.bounds.size.height
    
    let top: CGFloat = {
        switch UIScreen.main.bounds.size.height {
        
        case 568:
            // iPhone 5, iPhone 5s, iPhone 5c, iPhone SE
            return 80
            
        case 667:
            // iPhone 6, iPhone 6s, iPhone 7, iPhone 8
            return 80
            
        case 736:
            // iPhone 6 Plus, iPhone 6s Plus, iPhone 7 Plus, iPhone 8 Plus
            return 80
            
        case 812:
            //iPhone X, iPhone XS, iPhone 12 mini
            return 120
            
        case 844:
            //iPhone 12, 12Pro
            return 120
            
        case 896:
            //iPhone XR, iPhone 11, iPhone XS, 11ProMax
            return 120
            
        case 926:
            // iPhone 12ProMax
            return 120
            
        default:
            return 120
        }
    }()
    
    let left :CGFloat = 25
    let right :CGFloat = 25
    
}
