//
//  DiscriptionLabel.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/11.
//

import UIKit

class CreateDiscriptionLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        text = "香典を受け取らない場合でも、芳名録としてご利用できます。香典を受け取る場合、手数料がかかります。"
        font = .systemFont(ofSize: 20, weight: .bold)
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

