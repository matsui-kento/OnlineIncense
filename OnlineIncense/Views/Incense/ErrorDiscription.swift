//
//  ErrorDiscription.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/18.
//

import UIKit

class ErrorDiscription: UILabel {
    
    init() {
        super.init(frame: .zero)
        textColor = .red
        font = .systemFont(ofSize: 18, weight: .bold)
        numberOfLines = 0
        text = ""
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
