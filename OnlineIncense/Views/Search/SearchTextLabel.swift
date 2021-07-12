//
//  SearchTextLabel.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/10.
//

import Foundation
import UIKit

class SearchTextLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        
        text = "名前と都道府県の両方が完全に一致する必要があります。"
        font = .systemFont(ofSize: 15, weight: .semibold)
        textColor = .black
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
