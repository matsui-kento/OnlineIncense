//
//  DeleteAccountTitleLabel.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/26.
//

import UIKit

class DeleteAccountTitleLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        text = "アカウントを削除について"
        font = .systemFont(ofSize: 30, weight: .bold)
        numberOfLines = 0
        textColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
