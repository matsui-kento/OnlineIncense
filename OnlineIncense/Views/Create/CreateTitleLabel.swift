//
//  TitleLabel.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/11.
//

import UIKit

class CreateTitleLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        text = "オンラインで香典を受け取りますか？"
        font = .systemFont(ofSize: 25, weight: .bold)
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
