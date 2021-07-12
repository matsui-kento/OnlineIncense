//
//  RejectionDiscription.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/11.
//

import Foundation
import UIKit

class RejectionDiscription: UILabel {
    
    init() {
        super.init(frame: .zero)
        text = "＊誠にご勝手ながら、香典は辞退しております。"
        font = .systemFont(ofSize: 18, weight: .bold)
        textColor = .black
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
