//
//  DetailTextLabel.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/11.
//

import UIKit

class CommonTitleLabel: UILabel {
    
    init(label: String) {
        super.init(frame: .zero)
        text = label
        font = .systemFont(ofSize: 20, weight: .bold)
        textColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
