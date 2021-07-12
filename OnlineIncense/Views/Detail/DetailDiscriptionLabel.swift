//
//  DetailDiscriptionLabel.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/11.
//

import UIKit

class DetailDiscriptionLabel: UILabel {
    
    init(label: String) {
        super.init(frame: .zero)
        text = label
        font = .systemFont(ofSize: 25, weight: .bold)
        textColor = .black
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

