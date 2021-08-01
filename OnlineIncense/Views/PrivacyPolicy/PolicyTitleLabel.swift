//
//  PolicyTitleLabel.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/08/01.
//

import Foundation
import UIKit

class PolicyTitleLabel: UILabel {
    
    init(label: String) {
        super.init(frame: .zero)
        text = label
        font = .systemFont(ofSize: 20, weight: .bold)
        textColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
